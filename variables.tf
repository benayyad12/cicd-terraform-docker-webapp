variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-3"
}

variable "ami" {
  type        = string
  description = "AMI ID for the EC2 instance. If empty, Terraform will auto-select the latest Amazon Linux 2023 ARM64 AMI."
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "The instance type for the EC2 instance"
}


variable "bucket_name" {
  type        = string
  description = "s3 bucket for terraform backend"
}

variable "dynamodb_name" {
  type        = string
  description = "dynamo db table for state locking"
}

variable "backend_key" {
  type        = string
  description = "path to terraform state file"
}


variable "pay_mode" {
  type        = string
  description = "Billing mode for DynamoDB table (e.g. PAY_PER_REQUEST)"
  default     = "PAY_PER_REQUEST"
}

variable "hkey" {
  type        = string
  description = "Attribute to use as the hash (partition) key for DynamoDB"
  default     = "LockID"
}


variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "docker_image" {
  type        = string
  description = "The Docker image to deploy on the EC2 instance"
}

variable "ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH (port 22). Use your public IP with /32, e.g. 1.2.3.4/32. Empty disables SSH ingress rule."
  default     = ""
}

variable "ssh_key_name" {
  type        = string
  description = "EC2 Key Pair name to enable SSH. Empty keeps key_name unset (SSH via key pair won't work)."
  default     = ""
}

