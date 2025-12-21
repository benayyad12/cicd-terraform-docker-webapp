variable "wrapper_vpc_id" {
	type        = string
	description = "VPC ID where the security group should be created"
}

variable "ssh_cidr" {
	type        = string
	description = "CIDR allowed to SSH (port 22). Empty disables the SSH rule."
	default     = ""
}