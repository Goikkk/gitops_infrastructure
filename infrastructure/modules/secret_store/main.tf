locals {
  eso_name = "aws-parameterstore"
}

resource "kubernetes_manifest" "secret_store" {
  manifest = yamldecode(templatefile("${path.module}/secret_store.yaml", {
    eso_name = local.eso_name,
    eso_namespace = var.eso_namespace,
    eso_sa = var.eso_sa,
    region = var.region
  }))
}