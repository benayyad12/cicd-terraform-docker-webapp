#!/usr/bin/env bash
set -euo pipefail

TFVARS_FILE=${1:-"values.tfvars"}

echo "👉 Terraform fmt"
terraform fmt -recursive

echo "👉 Terraform init"
terraform init -input=false

echo "👉 Terraform validate"
terraform validate

echo "👉 Terraform plan"
terraform plan -input=false -var-file="${TFVARS_FILE}"

echo "✅ Terraform checks completed successfully"
