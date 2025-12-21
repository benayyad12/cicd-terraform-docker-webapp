variable "ami_id" {
  type        = string
  description = "The AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "The instance type for the EC2 instance"
}

variable "docker_image" {
  type        = string
  description = "The Docker image to deploy on the EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the instance should be launched"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the instance"
}