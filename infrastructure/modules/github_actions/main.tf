resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://${var.oidc_provider_domain}"
  client_id_list = var.audiences
}

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_domain}:aud"
      values   = var.audiences
    }

    condition {
      test     = "StringLike"
      variable = "${var.oidc_provider_domain}:sub"
      values   = var.subject_claim_values
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name                 = "${var.resource_name_prefix}-github-actions-role"
  assume_role_policy   = data.aws_iam_policy_document.github_actions_trust.json
  max_session_duration = 3600
}

data "aws_iam_policy_document" "github_actions_document" {
  statement {
    sid    = "AllowECRAuth"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowECRPush"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [var.ecr_repository_arn]
  }
}

resource "aws_iam_policy" "github_actions_policy" {
  name   = "${var.resource_name_prefix}-ecr-auth-policy"
  policy = data.aws_iam_policy_document.github_actions_document.json
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_auth_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
