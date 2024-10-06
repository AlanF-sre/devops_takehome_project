#/bin/bash

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

db_external_ip=$(gcloud sql instances describe $db_instance --format="value(ipAddresses[0].ipAddress)")

# Should write a function that verifies input
gcloud sql users set-password $username --instance=$db_instance --password=$password

# Adds base data
docker run --rm -e DATABASE_URL="postgres://$username:$password@$db_external_ip:5432/$database" \
  ghcr.io/saleor/saleor:3.20 python3 manage.py migrate

# Populates more data and creates the admin@example.com:admin UI user
docker run --rm -e DATABASE_URL="postgres://$username:$password@$db_external_ip:5432/$database" \
  ghcr.io/saleor/saleor:3.20 python3 manage.py populatedb --createsuperuser
