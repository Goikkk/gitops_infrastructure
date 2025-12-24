include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/secret_store"
}

dependency "eks" {
  config_path = "../eks"
}

dependency "eso" {
  config_path = "../eso"
}

inputs = {
  region = include.root.locals.region
  eso_namespace = dependency.eso.outputs.eso_namespace
  eso_sa = dependency.eso.outputs.eso_sa

  cluster_name    = dependency.eks.outputs.cluster_name
  cluster_endpoint    = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
}
