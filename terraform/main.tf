# Terraform Settings
# https://www.terraform.io/language/settings#terraform-settings
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "YOUR_BUCKET"
    key            = "tf-lab.tfstate"
    region         = "YOUR_REGION"
    dynamodb_table = "YOUR_DDB"
  }
}


# Provider Settings
# https://www.terraform.io/language/providers
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.project_name
      Name        = var.project_name
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
  mof_directory   = var.mof_directory
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

module "config" {
  source            = "./modules/config"
  ssm_parameters    = var.ssm_parameters
  ec2_names_and_ids = module.compute.ec2_names_and_ids
  dsc_bucket_name   = module.core.dsc_bucket_name
}
