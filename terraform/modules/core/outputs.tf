# https://www.terraform.io/language/values/outputs
# S3 Outputs
output "dsc_bucket_name" {
  value       = aws_s3_bucket.this.id
  description = "Name of the bucket"
}
# VPC Outputs
output "key_pair_name" {
  value       = aws_key_pair.this.key_name
  description = ""
}
output "sg_id" {
  value       = aws_security_group.this.id
  description = ""
}
output "first_subnet_id" {
  value       = aws_subnet.public[0].id
  description = ""
}
# IAM Outputs
output "ssm_instance_profile_name" {
  value       = aws_iam_instance_profile.ssm_instance_profile.name
  description = "Name of IAM EC2 instance profile for SSM"
}
