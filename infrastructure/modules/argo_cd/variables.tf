variable "eso_name" {
  type = string
}

variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "refresh_interval" {
  type = string
  default = "1m"
}

variable "argo_chart_version" {
  type = string
  default = "9.1.9"
}

variable "argo_image_updater_chart_version" {
  type = string
  default = "0.14.0"
}

variable "oidc_provider" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
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
