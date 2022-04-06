#resource "aws_kms_key" "this" {
#  description         = "KMS key for prod backup vault"
#  enable_key_rotation = true
#}
#
#resource "aws_kms_alias" "this" {
#  name          = "alias/backup_key_alias"
#  target_key_id = aws_kms_key.this.key_id
#}
#
#resource "aws_backup_vault" "this" {
#  name        = "backup_vault"
#  kms_key_arn = aws_kms_key.this.arn
#}
#
#resource "aws_backup_plan" "this" {
#  name = "backup_plan"
#  rule {
#    target_vault_name = aws_backup_vault.this.name
#    rule_name         = "backup_all_ec2_rule"
#    completion_window = 10080               # 7 days
#    schedule          = "cron(0 5 ? * * *)" # daily at 5am UTC
#    start_window      = 480                 # 8 hours
#    lifecycle {
#      cold_storage_after = 0
#      delete_after       = 2
#    }
#  }
#
#  depends_on = [aws_backup_vault.this]
#}
#
## Includes all ec2 except those tagged as replication server
#resource "aws_backup_selection" "this" {
#  name         = "all_ec2_selection"
#  iam_role_arn = var.default_backup_iam_role
#  plan_id      = aws_backup_plan.this.id
#  resources    = ["arn:aws:ec2:*:*:instance/*"]
#  condition {
#    string_not_equals {
#      key   = "aws:ResourceTag/Name"
#      value = "AWS Application Migration Service Replication Server"
#    }
#  }
#}