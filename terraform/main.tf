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


# Resources
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}
