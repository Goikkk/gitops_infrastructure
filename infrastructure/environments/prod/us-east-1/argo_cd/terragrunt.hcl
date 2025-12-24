include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/argo_cd"
}

dependency "ecr" {
  config_path = "../ecr"
}

dependency "eks" {
  config_path = "../eks"
}

dependency "secret_store" {
  config_path = "../secret_store"
}

inputs = {
  env      = include.root.locals.env
  region   = include.root.locals.region

  ecr_repository_arn = dependency.ecr.outputs.repository_arn

  eso_name = dependency.secret_store.outputs.eso_name

  oidc_provider = dependency.eks.outputs.oidc_provider
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

  cluster_name    = dependency.eks.outputs.cluster_name
  cluster_endpoint    = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
}
