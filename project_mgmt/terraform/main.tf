terraform {
  backend "gcs" {
    bucket  = "TERRAFORM_BUCKET_NAME"
    prefix  = "project_creation"
  }
}

provider "google" {
  credentials = file(var.gcp_creds)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.saleor_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.saleor_cluster.master_auth[0].cluster_ca_certificate)
}

resource "google_container_cluster" "saleor_cluster" {
  name     = "saleor-cluster"
  location = var.gcp_region
  
  deletion_protection = false
  initial_node_count  = 1

  release_channel {
    channel = "STABLE"
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 10
    service_account = google_service_account.saleor_cluster_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      application = "saleor"
    }
    tags = ["saleor"]
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 3
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 1
      maximum       = 5
    }
  }
}

data "google_client_config" "default" {}

resource "kubernetes_namespace" "saleor_namespace" {
  metadata {
    name = "saleor-namespace"
  }
}
