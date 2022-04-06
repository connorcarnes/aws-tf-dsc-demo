variable "project_name" {
  default = ""
  description = "Prefix for all resources"
}
# EC2 Variables
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
# Data sources
# Windows_Server-2022-English-Full-SQL_2019_Standard
data "aws_ami" "latest_windows_server_core" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Core-Base-*"]
  }
}
data "aws_ami" "latest_windows_server_full" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}
# Locals
locals {
  data_disks = tomap({
    for k, inst in aws_instance.this : k => {
      id             = inst.id
      data_disk_size = var.ec2_data[k]["data_disk_size"]
      az             = var.ec2_data[k]["az"]
    } if var.ec2_data[k]["data_disk_size"] != 0
  })
}