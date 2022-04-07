# https://www.terraform.io/language/values/variables
variable "project_name" {
  default = ""
  description = "Prefix for all resources"
}
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
variable "ssm_parameters" {
  default     = {}
  description = "Parameters to pass to the SSM Parameter Store"
}
variable "ec2_names_and_ids" {
  default     = {}
  description = "Map of instance names and ids"
}