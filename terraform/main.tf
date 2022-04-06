# Terraform Settings
# https://www.terraform.io/language/settings#terraform-settings
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "tflab-514215195183-terraform-s3-backend"
    key            = "tf-lab.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "6e6fc45e-c003-4f4e-8bdd-bdb2333c00cb"
    dynamodb_table = "tf-lab-backend-DDBStateLockingTable-110388H5STNR3"
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

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
  default_tags {
    tags = {
      Environment = "tf-lab"
      Name        = "tf-lab"
    }
  }
}

# Modules
module "core" {
  source = "./modules/core"

  dsc_bucket_name = var.dsc_bucket_name
  key_path        = "../keys/demolab.pub"
  vpc_name        = var.key_path
  vpc_cidr        = var.vpc_cidr
  subnets         = var.subnets
  pdc_ip          = var.pdc_ip
  dns_ips         = var.dns_ips
  management_ips  = var.management_ips
}

module "compute" {
  source = "./modules/compute"

  key_pair_name             = module.core.key_pair_name
  vpc_security_group_ids    = [module.core.sg_id]
  first_subnet_id           = module.core.first_subnet_id
  ssm_instance_profile_name = module.core.ssm_instance_profile_name
  ec2_data                  = var.ec2_data
}

module "config" {
  source = "./modules/config"

  ec2_names_and_ids = module.compute.ec2_names_and_ids
  dsc_bucket_name   = module.core.dsc_bucket_name
}

#resource "aws_lb" "example" {
#  name               = "example"
#  load_balancer_type = "network"
#  internal           = true
##
#  subnet_mapping {
#    subnet_id            = "subnet-01c56ff59647f2b0c"
#    private_ipv4_address = "10.0.1.16"
#  }
##
#  subnet_mapping {
#    subnet_id            = "subnet-099c09e5f0edc6287"
#    private_ipv4_address = "10.0.2.16"
#  }
#}