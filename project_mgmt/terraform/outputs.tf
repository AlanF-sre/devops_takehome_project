output "cluster_endpoint" {
  value = google_container_cluster.saleor_cluster.endpoint
}

output "cluster_name" {
  value = google_container_cluster.saleor_cluster.name
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.saleor_cluster.master_auth[0].cluster_ca_certificate
  sensitive = true
}

output "saleor_namespace_name" {
  value = kubernetes_namespace.saleor_namespace.metadata[0].name
}

output "db_instance_name" {
  value = google_sql_database_instance.saleor_db_instance.name
}

output "db_name" {
  value = google_sql_database.saleor_database.name
}

output "db_username" {
  value = google_sql_user.saleor_sql_user.name
}
