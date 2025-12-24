include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/argo_cd_application"
}

dependency "eks" {
  config_path = "../eks"
}

dependency "argo_cd" {
  config_path = "../argo_cd"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config/${include.root.locals.env}/config.hcl"))
}

inputs = {
  app_name = local.config.locals.app_name
  github_repo_url = local.config.locals.github_repo_url

  env      = include.root.locals.env
  region   = include.root.locals.region

  argocd_namespace = dependency.argo_cd.outputs.argocd_namespace
  git_secret_name = dependency.argo_cd.outputs.git_secret_name

  cluster_name    = dependency.eks.outputs.cluster_name
  cluster_endpoint    = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
}
