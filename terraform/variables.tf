# https://www.terraform.io/language/values/variables
#--------------------------------------------------------------
# Data Sources
#--------------------------------------------------------------

data "aws_caller_identity" "current" {}

#--------------------------------------------------------------
# Locals
#--------------------------------------------------------------

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}
#--------------------------------------------------------------
# Variables
#--------------------------------------------------------------

variable "name_prefix" {
  default = ""
  description = "Prefix for all resources"
}

variable "project_name" {
  default = ""
  description = "Name of project. Used in tagging and naming resources."
}

# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = ""
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC."
  default     = ""
}

variable "subnets" {
  type        = list(string)
  description = "CIDR ranges for the subnets."
  default     = []
}

variable "pdc_ip" {
  type        = string
  description = "IP address of the primary domain controller. Used to configure the aws_vpc_dhcp_options resource for the VPC."
  default     = ""
}

variable "dns_ips" {
  type        = list(string)
  description = "Populates the domain_name_servers field of the aws_vpc_dhcp_options resource for the VPC. If pdc_ip is set, pdc_ip will be first in the list."
  default     = []
}

variable "management_ips" {
  type        = list(string)
  description = "IP addresses of machines that will be used to manage VPC resources via RDP, SSH or WinRM."
  default     = []
}

variable "key_path" {
  default = ""
  description = "Path to ssh keys used to managed instances in the VPC."
}

variable "dsc_bucket_name" {
  type        = string
  description = "Name of S3 bucket that will be used to store MOFs and SSM logs."
  default     = ""
}

variable "ec2_data" {
  description = "Data used to configure ec2 resource. The key will be the ec2 name."
  type = map(object({
    associate_public_ip_address = bool
    instance_type               = string
    private_ip                  = string
    az                          = string
    data_disk_size              = number
  }))
  default = {}
}

variable "key_pair_name" {
  default = ""
  description = "Name of the key pair to use for SSH access to the instances"
}

variable "vpc_security_group_ids" {
  default = []
  description = "IDs of the VPC security groups to apply to the instances"
}

variable "first_subnet_id" {
  default = ""
  description = "ID of the first subnet to use for the instances"
}

variable "ssm_instance_profile_name" {
  default = ""
  description = "Name of the IAM EC2 instance profile for SSM"
}

variable "ssm_parameters" {
  default     = {}
  description = "Parameters to pass to the SSM Parameter Store"
  #sensitive   = true
}