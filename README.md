# CI/CD Terraform Docker Web App (AWS EC2)

End-to-end DevOps demo: build a Dockerized Nginx web app with GitHub Actions, push it to Docker Hub, and deploy/run it automatically on an AWS EC2 instance provisioned by Terraform.

## What this project does

- Builds a lightweight Nginx container serving a static page from [app/index.html](app/index.html) (see [Dockerfile](Dockerfile)).
- Runs a GitHub Actions pipeline (self-hosted runner) that:
  - Builds the Docker image
  - Scans the Dockerfile and image with Trivy
  - Pushes the image to Docker Hub
- Provisions AWS infrastructure using Terraform modules:
  - VPC with a public subnet, Internet Gateway, and route table
  - Security group allowing HTTP (80) from the internet
  - Optional SSH access for AWS **EC2 Instance Connect** (22) via a configurable CIDR
  - EC2 instance that installs Docker on boot and runs the configured Docker image on port 80
  - S3 + DynamoDB used for Terraform remote state and state locking

## Architecture (high level)

```
Developer/GitHub
  |  push to main
  v
GitHub Actions (self-hosted runner)
  |  build + scan + push
  v
Docker Hub (image)
  |
  |  EC2 user_data: docker pull + docker run
  v
AWS EC2 (public subnet) ---> Internet ---> Browser: http://<public-ip>/
```

## Repository layout

- GitHub Actions workflow: [.github/workflows/ci.yaml](.github/workflows/ci.yaml)
- Terraform root: [main.tf](main.tf), [variables.tf](variables.tf), [values.tfvars](values.tfvars)
- Terraform modules:
  - VPC: [modules/vpc](modules/vpc)
  - EC2: [modules/ec2](modules/ec2)
  - Security Group: [modules/security_group](modules/security_group)
  - S3 backend bucket: [modules/s3](modules/s3)
  - DynamoDB lock table: [modules/dynamodb](modules/dynamodb)
- Terraform quick checks: [check-terraform.sh](check-terraform.sh)

## Prerequisites

- Terraform installed
- AWS credentials configured locally (e.g., `aws configure` or env vars)
- A Docker Hub account
- A GitHub **self-hosted runner** with:
  - Docker installed
  - Trivy installed (`trivy` available on PATH)

## Configuration

Terraform variables are set in [values.tfvars](values.tfvars). Key values:

- `region`: default is `eu-west-3`
- `docker_image`: Docker Hub image to run on EC2 (example: `benayyad12/nginx-simple-web-app:1.0.0`)
- `ssh_cidr`: CIDR allowed to SSH (port 22). Empty disables SSH.
  - For AWS **EC2 Instance Connect** in `eu-west-3`, the AWS-managed range is commonly `35.180.112.80/29`.

## Deploy (Terraform)

From the repo root:

```bash
terraform init
terraform apply -var-file=values.tfvars
```

Optional: run formatting/validation/plan with:

```bash
./check-terraform.sh values.tfvars
```

## Verify the web app

1) Get the EC2 public IPv4 from AWS Console (or Terraform state).

2) Open in a browser:

- `http://<EC2_PUBLIC_IP>/`

Or via CLI:

```bash
curl -i http://<EC2_PUBLIC_IP>/
```

Expected: `HTTP/1.1 200 OK` and the HTML page.

## (Optional) Connect to the instance (AWS Portal)

This project can enable AWS **EC2 Instance Connect** (browser-based SSH) by allowing port 22 from a CIDR.

- Ensure [values.tfvars](values.tfvars) has `ssh_cidr` set (not empty)
- Apply Terraform
- In AWS Console: EC2 → Instance → **Connect** → **EC2 Instance Connect**
  - User: `ec2-user`

Once connected, you can verify Docker:

```bash
sudo docker ps
curl -i http://localhost/
```

## CI/CD pipeline

The workflow in [.github/workflows/ci.yaml](.github/workflows/ci.yaml) runs on pushes to `main` when `Dockerfile`, `app/**`, or the workflow itself changes.

It expects these GitHub Secrets:

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`
- `IMAGE_NAME`
- `IMAGE_TAG`

It builds and pushes:

- `$DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG`

## Notes / Troubleshooting

- If the EC2 instance is ARM64 (e.g., `t4g.*`), your Docker image must support `linux/arm64`.
  - If your CI builds only `linux/amd64`, the EC2 `docker pull` may fail with a manifest/architecture mismatch.
- If you can access HTTP but cannot connect with Instance Connect:
  - Confirm `ssh_cidr` is not empty and Terraform applied successfully.
  - Confirm the instance is in a public subnet and has a public IPv4.

## Cleanup

Destroy everything created by Terraform:

```bash
terraform destroy -var-file=values.tfvars
```

