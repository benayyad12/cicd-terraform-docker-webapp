variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "wrapped_security_group_id" {
  type        = string
  description = "The ID of the security group to wrap"
}