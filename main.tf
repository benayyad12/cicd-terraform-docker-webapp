module "ec2" {
  source        = "./modules/ec2"
  ami_id        = var.ami
  instance_type = var.instance_type
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  region      = var.region
}

module "dynamodb" {
  source        = "./modules/dynamodb"
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
}