output "eso_namespace" {
  description = "Name of the External Secret Operator namespace"
  value       = local.eso_namespace
}

output "eso_sa" {
  description = "Name of the External Secret Operator service account"
  value       = local.eso_sa
}