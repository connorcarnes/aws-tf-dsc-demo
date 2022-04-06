# Terraform Settings
# https://www.terraform.io/language/settings#terraform-settings
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "demo-514215195183-terraform-s3-backend"
    key            = "tf-lab.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demo-stack-DDBStateLockingTable-6JAORL4JJ41Q"
  }
}


# Provider Settings
# https://www.terraform.io/language/providers
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "tf-lab"
      Name        = "tf-lab"
    }
  }
}


# Modules
# https://www.terraform.io/language/modules
module "core" {
  source          = "./modules/core"
  project_name    = var.project_name
  dsc_bucket_name = var.dsc_bucket_name
  key_path        = var.key_path
  vpc_cidr        = var.vpc_cidr
  subnets         = var.subnets
  pdc_ip          = var.pdc_ip
  dns_ips         = var.dns_ips
  management_ips  = var.management_ips
}

module "compute" {
  source                    = "./modules/compute"
  key_pair_name             = module.core.key_pair_name
  vpc_security_group_ids    = [module.core.sg_id]
  first_subnet_id           = module.core.first_subnet_id
  ssm_instance_profile_name = module.core.ssm_instance_profile_name
  ec2_data                  = var.ec2_data
}