data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "external_secrets_ssm" {
  name = "external-secrets-ssm-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/argocd/admin-password",
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/argocd/admin-passwordMtime",
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/argocd/server-secretkey",
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/git/username",
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/git/password"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "external_secrets" {
  name = "external-secrets-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" = "system:serviceaccount:${local.eso_namespace}:${local.eso_sa}",
            "${var.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets_ssm" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets_ssm.arn
}