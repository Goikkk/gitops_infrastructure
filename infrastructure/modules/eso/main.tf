locals {
  eso_namespace = "external-secrets"
  eso_sa = "external-secrets"
}

resource "kubernetes_namespace" "eso" {
  metadata {
    name = local.eso_namespace
  }
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = local.eso_namespace
  create_namespace = false
  version    = "1.2.0"

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.external_secrets.metadata[0].name
      }
    })
  ]
}

resource "kubernetes_service_account" "external_secrets" {
  metadata {
    name      = local.eso_sa
    namespace = local.eso_namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_secrets.arn
    }
  }

  depends_on = [kubernetes_namespace.eso]
}

