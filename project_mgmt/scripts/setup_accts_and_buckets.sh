#/bin/bash

gcp_project=$(gcloud config get-value project)
tf_bucket_name="terraform-$gcp_project"

gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable iamcredentials.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable servicenetworking.googleapis.com

gcloud iam service-accounts create terraform-creator-sa \
  --description="Service Account for setting up project via Terraform" \
  --display-name="Terraform Creator Service Account"

gcloud iam service-accounts keys create project_mgmt/terraform/terraform-creator-key.json \
  --iam-account=terraform-creator-sa@$gcp_project.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $gcp_project \
    --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
    --role=roles/compute.networkAdmin

gcloud projects add-iam-policy-binding $gcp_project \
    --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
    --role=roles/cloudsql.admin

gcloud projects add-iam-policy-binding $gcp_project \
    --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
    --role=roles/iam.securityAdmin

gcloud projects add-iam-policy-binding $gcp_project \
    --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
    --role=roles/storage.admin

gcloud projects add-iam-policy-binding $gcp_project \
    --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountAdmin

gcloud projects add-iam-policy-binding $gcp_project \
    --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountKeyAdmin

gcloud projects add-iam-policy-binding $gcp_project \
  --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
  --role=roles/secretmanager.admin

gcloud projects add-iam-policy-binding $gcp_project \
  --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
  --role=roles/container.admin

gcloud projects add-iam-policy-binding $gcp_project \
  --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
  --role=roles/compute.instanceAdmin

gcloud projects add-iam-policy-binding $gcp_project \
  --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
  --role=roles/artifactregistry.admin

gcloud projects add-iam-policy-binding $gcp_project \
  --member=serviceAccount:terraform-creator-sa@$gcp_project.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountUser

gcloud storage buckets create gs://$tf_bucket_name --location=asia-northeast1

echo "Using $tf_bucket_name for terraform state"
