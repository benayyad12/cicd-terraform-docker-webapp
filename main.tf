data "aws_ami" "amazon_linux_2023_arm64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  ec2_ami_id = var.ami != "" ? var.ami : data.aws_ami.amazon_linux_2023_arm64.id
}

module "ec2" {
  source        = "./modules/ec2"
  ami_id        = local.ec2_ami_id
  instance_type = var.instance_type
  docker_image  = var.docker_image
  subnet_id     = module.vpc.public_subnet_id
  security_group_ids = [
    module.security_group.aws_security_group_id,
  ]
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  region      = var.region
}

module "dynamodb" {
  source        = "./modules/dynamodb"
  count         = var.enable_dynamodb_lock_table ? 1 : 0
  dynamodb_name = var.dynamodb_name
  pay_mode      = var.pay_mode
  hkey          = var.hkey
}

module "vpc" {
  source                    = "./modules/vpc"
  vpc_cidr                  = var.vpc_cidr
  wrapped_security_group_id = module.security_group.aws_security_group_id

}

module "security_group" {
  source         = "./modules/security_group"
  wrapper_vpc_id = module.vpc.vpc_id
  ssh_cidr       = var.ssh_cidr
}