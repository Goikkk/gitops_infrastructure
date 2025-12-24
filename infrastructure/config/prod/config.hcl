locals {
  app_name = "simple-app"

  # URL to github repo containing application manifests
  github_repo_url = "https://github.com/Goikkk/gitops_applications"

  # GitHub repositories (and optionally a branch/tag/environment) that will have access to the aws account
  # Case sensitive!
  # Doc: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
  git_subject_claim_values = ["repo:Goikkk/gitops_infrastructure:*"]

  # ARN of a cluster admin user / role
  cluster_admin_arn = "arn:aws:iam::914567108126:user/terragrunt"

  # EKS node group configuration
  main_node_group = {
    instance_types = ["t3.large", "m5.large"]
    disk_size = 20

    min_size = 1
    max_size = 2
    desired_size = 1
  }
}