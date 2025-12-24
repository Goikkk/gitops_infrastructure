variable "resource_name_prefix" {
  type = string
}

variable "subject_claim_values" {
  description = "[case sensitive] GitHub repositories (and optionally a branch/tag/environment). Doc: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws"
  type        = list(string)
}

variable "ecr_repository_arn" {
  type = string
}

variable "oidc_provider_domain" {
  type    = string
  default = "token.actions.githubusercontent.com"
}

variable "audiences" {
  type    = list(string)
  default = ["sts.amazonaws.com"]
}