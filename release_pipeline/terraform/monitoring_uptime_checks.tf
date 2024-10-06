resource "google_monitoring_uptime_check_config" "saleor_dashboard_uptime_check" {
  display_name = "Uptime check saleor-dashboard"

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project
      host       = kubernetes_service.saleor_dashboard_loadbalancer.status.0.load_balancer.0.ingress.0.ip
    }
  }

  http_check {
    path           = "/"
    port           = 80
    request_method = "GET"
    use_ssl        = false
    validate_ssl   = false
  }

  timeout = "10s"
  period  = "60s"

  selected_regions = ["ASIA_PACIFIC", "EUROPE", "USA_VIRGINIA"]
}
