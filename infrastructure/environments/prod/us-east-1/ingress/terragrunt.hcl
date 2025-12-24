include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/ingress"
}

dependency "eks" {
  config_path = "../eks"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config/${include.root.locals.env}/config.hcl"))
}

inputs = {
  app_name = local.config.locals.app_name

  cluster_name    = dependency.eks.outputs.cluster_name
  cluster_endpoint    = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
}
