include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/github_actions"
}

dependency "ecr" {
  config_path = "../ecr"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config/${include.root.locals.env}/config.hcl"))
}

inputs = {
  resource_name_prefix = include.root.locals.resource_name_prefix
  subject_claim_values = local.config.locals.git_subject_claim_values
  ecr_repository_arn   = dependency.ecr.outputs.repository_arn
}
