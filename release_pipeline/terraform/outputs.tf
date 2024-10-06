output "dashboard_ip" {
  value = kubernetes_service.saleor_dashboard_loadbalancer.status.0.load_balancer.0.ingress.0.ip
  description = "The external IP address of the service"
}
