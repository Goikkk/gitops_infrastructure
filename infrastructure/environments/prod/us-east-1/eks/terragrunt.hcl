include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/eks/aws?version=21.9.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config/${include.root.locals.env}/config.hcl"))
}

inputs = {
  name               = include.root.locals.resource_name_prefix
  kubernetes_version = 1.34

  upgrade_policy = {
    support_type = "STANDARD"
  }

  enable_irsa = true

  vpc_id                   = dependency.vpc.outputs.vpc_id
  subnet_ids               = dependency.vpc.outputs.private_subnets
  control_plane_subnet_ids = dependency.vpc.outputs.private_subnets
  endpoint_public_access   = true

  eks_managed_node_groups = {
    main = local.config.locals.main_node_group
  }

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  access_entries = {
    admin = {
      principal_arn = local.config.locals.cluster_admin_arn

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}
