data "kubernetes_service" "nginx_ingress_service" {
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [helm_release.nginx_ingress]
}

output "nginx_ingress_service_ip" {
  value     = data.kubernetes_service.nginx_ingress_service.status.0.load_balancer.0.ingress.0.ip
  sensitive = true
}
