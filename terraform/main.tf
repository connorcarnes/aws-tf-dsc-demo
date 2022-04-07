# Terraform Settings
# https://www.terraform.io/language/settings#terraform-settings
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "demostack-514215195183-terraform-s3-backend"
    key            = "tf-lab.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demo-stack-DDBStateLockingTable-18DAW4WRCSZVT"
  }
}


# Provider Settings
# https://www.terraform.io/language/providers
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "aws-tf-dsc-demo"
      Name        = "aws-tf-dsc-demo"
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