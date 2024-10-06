resource "google_storage_bucket" "logs_bucket" {
  name          = "cloudbuild-logs-${data.google_client_config.default.project}"
  location      = "US"
  storage_class = "STANDARD"
  project       = var.gcp_project
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 1
    }
  }

  soft_delete_policy {
    retention_duration_seconds = 604800 # 1 week
  }
}
