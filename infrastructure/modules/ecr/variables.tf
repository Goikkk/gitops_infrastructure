variable "repository_name" {
  type = string
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "image_limit" {
  description = "Number of images that will be kept in ECR"
  type        = number
  default     = 10
}
