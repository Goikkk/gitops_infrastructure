variable "app_name" {
  type = string
}

variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "argocd_namespace" {
  type    = string
}

variable "git_secret_name" {
  type    = string
}

variable "github_repo_url" {
  type    = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_certificate_authority_data" {
  type = string
}
