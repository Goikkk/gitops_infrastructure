locals {
  argocd_server_name = "argocd-server"
  git_secret = "git-credentials"
}

resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd_namespace.metadata[0].name
  create_namespace = true
  version    = var.argo_chart_version

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }

        ingress = {
          enabled = false
        }
      }

      configs = {
        params = {
          "server.insecure" = true
          "server.basehref" = "/argocd"
          "server.rootpath" = "/argocd"
        }

        secret = {
          createSecret = false
        }
      }
    })
  ]

  depends_on = [kubernetes_manifest.argocd_secret]
}

resource "kubernetes_manifest" "argocd_secret" {
  manifest = yamldecode(templatefile("${path.module}/argocd_secret.yaml", {
    secret_name = "argocd-secret",
    eso_name = var.eso_name,
    argocd_namespace = kubernetes_namespace.argocd_namespace.metadata[0].name,
    refresh_interval = var.refresh_interval
  }))
}

resource "kubernetes_manifest" "git_secret" {
  manifest = yamldecode(templatefile("${path.module}/git_secret.yaml", {
    secret_name = local.git_secret,
    eso_name = var.eso_name,
    argocd_namespace = kubernetes_namespace.argocd_namespace.metadata[0].name,
    refresh_interval = var.refresh_interval
  }))
}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name      = "argocd-server-ingress"
    namespace = kubernetes_namespace.argocd_namespace.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/argocd"
          path_type = "Prefix"

          backend {
            service {
              name = local.argocd_server_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}
