variable "gcp_creds" {
  description = "File with service account key for deployment"
  sensitive   = true
}

variable "gcp_project" {
  description = "Project to deploy to"
}

variable "gcp_region" {
  description = "Default region for region specific resources"
}

variable "gcp_zone" {
  description = "Zone to use, GCP resources not available in all zones"
}

variable "db_instance_name" {
  description = "Name of the database instance to deploy"
  default     = "prod-saleor-db-instance"
}

variable "db_name" {
  description = "Name of the database to deploy"
  default     = "prod-saleor"
}

variable "db_allowed_ip_range" {
  description = "IP range for allowing network traffic for project setup. Example: 127.0.0.1/32"
}
