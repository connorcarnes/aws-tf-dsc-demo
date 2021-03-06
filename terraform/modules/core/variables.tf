# https://www.terraform.io/language/values/variables
variable "project_name" {
  default = ""
  description = "Prefix for all resources"
}
# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
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
# S3 Variables
variable "dsc_bucket_name" {
  type        = string
  description = "Name of S3 bucket that will be used to store MOFs and SSM logs."
  default     = ""
}
variable "mof_directory" {
  type        = string
  description = "Path to directory on your build machine that contains required MOF files. Can be absolute or relative to the root module directory."
  default     = ""
}
# Data Sources
# https://www.terraform.io/language/data-sources
data "aws_availability_zones" "available" {
  state = "available"
}