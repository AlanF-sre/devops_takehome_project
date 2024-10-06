resource "kubernetes_service" "saleor_dashboard_loadbalancer" {
  metadata {
    name      = "saleor-dashboard-loadbalancer"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name
  }

  spec {
    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
    }

    selector = {
      app = "saleor-dashboard"
    }
  }
}

resource "kubernetes_service" "saleor_api" {
  metadata {
    name      = "saleor-api"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name
  }

  spec {
    type = "NodePort"

    port {
      port        = 8000
      target_port = 8000
    }

    selector = {
      app = "saleor-api"
    }
  }
}

resource "kubernetes_service" "saleor_dashboard" {
  metadata {
    name      = "saleor-dashboard"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name
  }

  spec {
    type = "NodePort"

    port {
      port        = 9000
      target_port = 80
    }

    selector = {
      app = "saleor-dashboard"
    }
  }
}

resource "kubernetes_service" "saleor_redis" {
  metadata {
    name      = "saleor-redis"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name
  }

  spec {
    port {
      port        = 6379
      target_port = 6379
    }

    selector = {
      app = "saleor-redis"
    }
  }
}
