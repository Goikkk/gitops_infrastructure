locals {
  env                  = split("/", path_relative_to_include())[1]
  region               = split("/", path_relative_to_include())[2]
  resource_name_prefix = "gitops-infra-${local.env}"
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket = "gitops-infrastructure-terraform-state-${local.env}-${local.region}"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
  }
}

generate "provider" {
  path = "provider_aws.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}
