output "argocd_namespace" {
  value = kubernetes_namespace.argocd_namespace.metadata[0].name
}

output "git_secret_name" {
  value = local.git_secret
}
