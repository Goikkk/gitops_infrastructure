resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.14.0"

  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
      }, {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
      }, {
      name  = "controller.replicaCount"
      value = "2"
      }, {
      name  = "controller.resources.requests.cpu"
      value = "100m"
      }, {
      name  = "controller.resources.requests.memory"
      value = "128Mi"
    }
  ]
}

resource "kubernetes_namespace" "application_namespace" {
  metadata {
    name = var.app_name
  }
}

resource "kubernetes_ingress_v1" "nginx_redirect_ingress" {
  metadata {
    name      = "nginx-app-ingress-rule"
    namespace = var.app_name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.app_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.nginx_ingress,
    kubernetes_namespace.application_namespace
  ]
}