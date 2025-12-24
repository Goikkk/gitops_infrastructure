include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/ecr"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config/${include.root.locals.env}/config.hcl"))
}

inputs = {
  repository_name = local.config.locals.app_name
  scan_on_push    = false
}
