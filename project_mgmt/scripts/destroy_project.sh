#/bin/bash

set -e

# Function to display usage
usage() {
    echo "Usage: $0 -i <db_instance> -d <database>"
    exit 1
}

# Initialize variables
database=""
db_instance=""

# This software creates its test data under one user. The one we use in TF needs to be used here too.
username="saleor_admin"
password=$(date +%s | sha256sum | base64 | head -c 16)
my_project=$(gcloud config get-value project)
tf_creator_sa="terraform-creator-sa@$my_project.iam.gserviceaccount.com"

# Parse options
while getopts "i:d:" opt; do
    case "$opt" in
        i) db_instance="$OPTARG" ;;
        d) database="$OPTARG" ;;
        *) usage ;;
    esac
done

# Check if all parameters were provided
if [[ -d "$database" || -z "$db_instance" ]]; then
    usage
fi

# Reset DB User"s password and drop all owned data
gcloud sql databases delete $database --instance=$db_instance --quiet

# Create service account key for deployer
gcloud iam service-accounts keys create terraform-creator-key.json --iam-account $tf_creator_sa

# Create service account key for creator
gcloud iam service-accounts keys create release_pipeline/terraform/tf-deployer-service-acct-key.json \
  --iam-account tf-deployer-service-acct@$my_project.iam.gserviceaccount.com

# Run Terraform destroy for product
pipeline_tf_path="./release_pipeline/terraform"
terraform -chdir="$pipeline_tf_path" init -reconfigure
terraform -chdir="$pipeline_tf_path" apply -destroy -auto-approve -lock=true \
  -var-file="props.tfvar" \
  -var="gcp_creds=tf-deployer-service-acct-key.json" \
  -var="gcp_project=$my_project"

# Terraform can't get delete this auto-generated peering. Deleting manually.
gcloud compute networks peerings delete servicenetworking-googleapis-com --network=saleor-prod-vpc-network

# Run terraform destroy for project
project_mgmt_tf_path="./project_mgmt/terraform"
terraform -chdir="$project_mgmt_tf_path" init -reconfigure
terraform -chdir="$project_mgmt_tf_path" apply -destroy -auto-approve -lock=true \
  -var-file="props.tfvar" \
  -var="gcp_project=$my_project" \
  -var="gcp_creds=terraform-creator-key.json" \
  -var="db_allowed_ip_range=127.0.0.1/32"

# Remove service accounts
gcloud iam service-accounts delete "$tf_creator_sa" --quiet

# Remove cloudbuild logs bucket
gcloud storage rm --recursive "gs://terraform-$my_project"
