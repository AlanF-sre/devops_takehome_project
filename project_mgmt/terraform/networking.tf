resource "google_compute_network" "saleor_network" {
  name                    = "saleor-prod-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "saleor_subnetwork" {
  name          = "saleor-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.gcp_region
  network       = google_compute_network.saleor_network.id
}

resource "google_compute_global_address" "saleor_db_private_ip" {
  name          = "saleor-db-private-ip"
  address_type  = "INTERNAL"
  network       = google_compute_network.saleor_network.id
  purpose       = "VPC_PEERING"
  prefix_length = 16
}

resource "google_service_networking_connection" "saleor_private_service_connection" {
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.saleor_db_private_ip.name]
  network                 = google_compute_network.saleor_network.id
}
