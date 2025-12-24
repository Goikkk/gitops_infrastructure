data "aws_caller_identity" "current" {}

locals {
  argocd_image_updater_name = "argocd-image-updater"
}

resource "helm_release" "argocd_image_updater" {
  name       = local.argocd_image_updater_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  version    = var.argo_image_updater_chart_version
  namespace  = kubernetes_namespace.argocd_namespace.metadata[0].name

  values = [
    templatefile("${path.module}/image_updater.yaml", {
      argocd_image_updater_name = local.argocd_image_updater_name,
      iam_role_arn = aws_iam_role.argocd_image_updater.arn,
      argocd_server_name = local.argocd_server_name,
      argocd_namespace = kubernetes_namespace.argocd_namespace.metadata[0].name,
      aws_account_id = data.aws_caller_identity.current.account_id,
      region = var.region
    })
  ]

  depends_on = [
    aws_iam_role_policy_attachment.argocd_image_updater_ecr
  ]
}

resource "aws_iam_role" "argocd_image_updater" {
  name = "argocd-image-updater-role"

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
            "${var.oidc_provider}:sub" = "system:serviceaccount:${kubernetes_namespace.argocd_namespace.metadata[0].name}:${local.argocd_image_updater_name}"
            "${var.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "argocd_image_updater_ecr" {
  name        = "argocd-image-updater-ecr-policy"
  description = "Policy for ArgoCD Image Updater to access ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:DescribeImageScanFindings"
        ]
        Resource = [var.ecr_repository_arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "argocd_image_updater_ecr" {
  role       = aws_iam_role.argocd_image_updater.name
  policy_arn = aws_iam_policy.argocd_image_updater_ecr.arn
}

