resource "google_sql_database_instance" "saleor_db_instance" {
  name             = var.db_instance_name
  database_version = "POSTGRES_16"
  region           = var.gcp_region

  deletion_protection = false

  settings {
    tier         = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.saleor_network.id
      ssl_mode        = "ENCRYPTED_ONLY"

      authorized_networks {
        name  = "Office Network"
        value = var.db_allowed_ip_range
      }
    }
    user_labels = {
      environment = "production"
      app         = "saleor"
    }
  }
  depends_on = [google_service_networking_connection.saleor_private_service_connection]
}

resource "google_sql_database" "saleor_database" {
  name     = var.db_name
  instance = google_sql_database_instance.saleor_db_instance.name
}

resource "random_password" "saleor_db_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "google_sql_user" "saleor_sql_user" {
  # Hard-coding this for demo purposes as the test data can only be reached by this user
  name     = "saleor_admin"
  instance = google_sql_database_instance.saleor_db_instance.name
  password = random_password.saleor_db_password.result

  lifecycle {
    ignore_changes = [
      password
    ]
  }
}
