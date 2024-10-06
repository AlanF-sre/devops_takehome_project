resource "google_secret_manager_secret" "tf_deploy_sa" {
  secret_id = "tf-deploy-sa"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "tf_deploy_sa_secret_version" {
  secret      = google_secret_manager_secret.tf_deploy_sa.id
  secret_data = base64decode(google_service_account_key.tf_deployer_sa_key.private_key)
}
