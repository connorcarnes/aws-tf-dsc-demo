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

# Resources
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}