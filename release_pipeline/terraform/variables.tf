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

variable "image_url" {
  description = "Domain of the docker image"
  default     = "asia-northeast1-docker.pkg.dev"
}

variable "image_tag" {
  description = "The image tag to use for this deploy"
  default     = "latest"
}

variable "image_path" {
  description = "The path within the repo for the images"
  default     = "saleor-repo"
}

# Splitting these replica vars as you may want to default based on stack.
# For example, dev stacks may get 1 replica but prod needs 3.
variable "redis_replicas" {
  description = "Number of replicas to use for each redis deployment"
  default     = 1
}

variable "dashboard_replicas" {
  description = "Number of replicas to use for each dashboard deployment"
  default     = 1
}

variable "api_replicas" {
  description = "Number of replicas to use for each api deployment"
  default     = 1
}
