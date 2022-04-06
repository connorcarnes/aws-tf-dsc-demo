# SSM State Manager Associations to apply MOFS to target instances
# https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-associations.html
# https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state-manager-using-mof-file.html
resource "aws_ssm_association" "this" {
  for_each = var.ec2_names_and_ids

  name             = "AWS-ApplyDSCMofs"
  association_name = "${each.key}"

  targets {
    key    = "InstanceIds"
    values = [each.value["id"]]
  }

  output_location {
    s3_bucket_name = var.dsc_bucket_name
    s3_key_prefix  = "corp/${each.key}"
  }

  parameters = {
    MofsToApply    = "s3:${var.dsc_bucket_name}:dsc/corp_domain/corp_domain/${each.key}.mof"
    RebootBehavior = "Immediately"
    #EnableVerboseLogging = "True"
  }
}

# SSM parameters used by DSC
resource "aws_ssm_parameter" "this" {
  for_each = var.ssm_parameters
  name  = "${each.key}"
  type  = "SecureString"
  value = "{\"Username\":\"${each.key}\", \"Password\":\"${each.value}\"}"
}