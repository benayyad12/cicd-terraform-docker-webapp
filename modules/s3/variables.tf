variable "bucket_name" {
  type        = string
  description = "Optional name or prefix for the S3 bucket. If empty, a randomized suffix is used."
}

variable "region" {
  type        = string
  description = "AWS region for resources created by this module (informational)."
}