resource "random_password" "saleor_db_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true

  depends_on = [null_resource.force_update]
}

resource "null_resource" "force_update" {
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "google_sql_user" "saleor_sql_user" {
  name     = data.terraform_remote_state.saleor_cluster.outputs.db_username
  instance = data.terraform_remote_state.saleor_cluster.outputs.db_instance_name
  password = random_password.saleor_db_password.result
}
