resource "google_artifact_registry_repository" "saleor_repo" {
  location      = var.gcp_region
  repository_id = "saleor-repo"
  description   = "Saleor GitHub repo"
  format        = "DOCKER"
}
