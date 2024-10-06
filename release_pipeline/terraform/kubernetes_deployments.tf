resource "kubernetes_deployment" "saleor_api" {
  metadata {
    name = "saleor-api"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name
    labels = {
      app = "saleor-api"
    }
  }

  spec {
    replicas = var.api_replicas

    selector {
      match_labels = {
        app = "saleor-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "saleor-api"
        }
      }

      spec {
        container {
          name  = "saleor-api"
          image = "${var.image_url}/${var.gcp_project}/${var.image_path}/saleor-core:${var.image_tag}"

          port {
            container_port = 8000
          }

          env {
            name = "DATABASE_URL"
            value = "postgres://${google_sql_user.saleor_sql_user.name}:${google_sql_user.saleor_sql_user.password}@127.0.0.1:5432/${data.terraform_remote_state.saleor_cluster.outputs.db_name}?sslmode=prefer"
          }

          volume_mount {
            name       = kubernetes_secret.cloud_sql_instance_credentials.metadata[0].name
            mount_path = "/secrets"
          }

          tty   = true
          stdin = true
        }

        container {
          name  = "cloud-sql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:latest"
          command = [
            "/cloud_sql_proxy",
            "-instances=${var.gcp_project}:${var.gcp_region}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}=tcp:5432",
            "-credential_file=/secrets/key.json"
          ]

          volume_mount {
            name       = kubernetes_secret.cloud_sql_instance_credentials.metadata[0].name
            mount_path = "/secrets"
          }

          port {
            container_port = 5432
          }
        }

        volume {
          name = kubernetes_secret.cloud_sql_instance_credentials.metadata[0].name
          secret {
            secret_name = kubernetes_secret.cloud_sql_instance_credentials.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "saleor_dashboard" {
  metadata {
    name = "saleor-dashboard"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name
    labels = {
      app = "saleor-dashboard"
    }
  }

  spec {
    replicas = var.dashboard_replicas

    selector {
      match_labels = {
        app = "saleor-dashboard"
      }
    }

    template {
      metadata {
        labels = {
          app = "saleor-dashboard"
        }
      }

      spec {
        container {
          name  = "saleor-dashboard"
          image = "${var.image_url}/${var.gcp_project}/${var.image_path}/saleor-dashboard:${var.image_tag}"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "saleor_redis" {
  metadata {
    name      = "saleor-redis"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name

    labels = {
      app = "saleor-redis"
    }
  }

  spec {
    replicas = var.redis_replicas

    selector {
      match_labels = {
        app = "saleor-redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "saleor-redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:7.0-alpine"

          port {
            container_port = 6379
          }
        }
      }
    }
  }
}
