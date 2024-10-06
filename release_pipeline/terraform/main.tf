terraform {
  backend "gcs" {
    bucket = "TERRAFORM_BUCKET_NAME"
    prefix = "prod"
  }
}

provider "google" {
  credentials = file(var.gcp_creds)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

data "terraform_remote_state" "saleor_cluster" {
  backend = "gcs"
  config = {
    bucket = "TERRAFORM_BUCKET_NAME"
    prefix = "project_creation"
  }
}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.saleor_cluster.outputs.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.saleor_cluster.outputs.cluster_ca_certificate)
}

data "google_client_config" "default" {}

provider "random" {}
