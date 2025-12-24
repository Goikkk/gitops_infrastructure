include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=6.5.1"
}

inputs = {
  name                 = include.root.locals.resource_name_prefix
  cidr                 = "10.0.0.0/16"
  azs                  = ["${include.root.locals.region}a", "${include.root.locals.region}b", "${include.root.locals.region}c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}
