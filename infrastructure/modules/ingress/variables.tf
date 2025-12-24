variable "app_name" {
  description = "Service of the app to which traffic will be redirected"
  type        = string
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
