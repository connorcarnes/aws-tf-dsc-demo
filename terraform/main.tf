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
  vpc_cidr        = var.vpc_cidr
  subnets         = var.subnets
  pdc_ip          = var.pdc_ip
  dns_ips         = var.dns_ips
  management_ips  = var.management_ips
}
