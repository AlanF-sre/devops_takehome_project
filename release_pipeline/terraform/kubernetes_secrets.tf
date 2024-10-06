resource "kubernetes_secret" "cloud_sql_instance_credentials" {
  metadata {
    name      = "cloud-sql-instance-credentials"
    namespace = data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name
  }

  data = {
    "key.json" = base64decode(google_service_account_key.cloud_sql_proxy_key.private_key)
  }
}
