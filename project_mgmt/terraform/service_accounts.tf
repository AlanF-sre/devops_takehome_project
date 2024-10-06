resource "google_service_account" "tf_deployer_service_acct" {
  account_id   = "tf-deployer-service-acct"
  display_name = "Service Account for Terraform deploys"
}

resource "google_service_account_key" "tf_deployer_sa_key" {
  service_account_id = google_service_account.tf_deployer_service_acct.name
}

resource "google_project_iam_member" "tf_deployer_sa_roles" {
  for_each = toset([
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iam.securityAdmin",
    "roles/container.admin",
    "roles/logging.logWriter",
    "roles/compute.instanceAdmin",
    "roles/storage.objectAdmin",
    "roles/cloudsql.admin",
    "roles/secretmanager.secretAccessor",
    "roles/monitoring.editor",
    "roles/storage.admin",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.writer",
  ])

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.tf_deployer_service_acct.email}"
}

resource "google_service_account" "saleor_cluster_sa" {
  account_id   = "saleor-cluster-sa"
  display_name = "Service Account for Saleor Cluster"
}

resource "google_project_iam_member" "saleor_cluster_sa_roles" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.reader",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ])

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.saleor_cluster_sa.email}"
}

resource "google_service_account" "cloudbuild_service_acct" {
  account_id   = "cloudbuild-service-acct"
  display_name = "Service Account for CI Builds in Cloud Build"
}

resource "google_project_iam_member" "cloudbuild_sa_roles" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.writer",
    "roles/storage.admin",
    "roles/cloudbuild.builds.editor",
    "roles/secretmanager.secretAccessor",
    "roles/logging.logWriter",
  ])

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloudbuild_service_acct.email}"
}
