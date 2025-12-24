data "aws_caller_identity" "current" {}

resource "kubernetes_manifest" "argocd_application" {
  manifest = yamldecode(templatefile("${path.module}/application.yaml", {
    app_name = var.app_name,
    app_namespace = var.app_name,
    argocd_namespace = var.argocd_namespace,
    account_id = data.aws_caller_identity.current.account_id,
    env = var.env,
    region = var.region,
    github_repo_url = var.github_repo_url,
    git_secret = var.git_secret_name
  }))
}
