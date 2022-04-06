#--------------------------------------------------------------
# EC2
#--------------------------------------------------------------
resource "aws_instance" "this" {
  for_each = var.ec2_data
  ami                         = data.aws_ami.latest_windows_server_core.image_id
  associate_public_ip_address = each.value["associate_public_ip_address"]
  instance_type               = each.value["instance_type"]
  private_ip                  = each.value["private_ip"]
  availability_zone           = each.value["az"]
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.first_subnet_id
  iam_instance_profile        = var.ssm_instance_profile_name
  # https://aws.amazon.com/premiumsupport/knowledge-center/ec2-windows-troubleshoot-user-data/
  user_data = <<EOF
  <powershell>
  Rename-Computer -NewName ${each.key} -Force -Restart
  </powershell>
  EOF
  tags = {
    Name = each.key
  }
}
#--------------------------------------------------------------
# EBS
# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-windows-volumes.html
#--------------------------------------------------------------
resource "aws_ebs_volume" "data" {
  for_each          = local.data_disks
  availability_zone = each.value["az"]
  size              = each.value["data_disk_size"]
  tags = {
    Name = "${each.key}"
  }
}
resource "aws_volume_attachment" "this" {
  for_each    = local.data_disks
  device_name = "xvdf"
  volume_id   = aws_ebs_volume.data[each.key].id
  instance_id = each.value["id"]
}