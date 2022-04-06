# https://www.terraform.io/language/values/outputs
output "ec2_names_and_ids" {
  value = tomap({
    for k, inst in aws_instance.this : k => {
      id = inst.id
    }
  })
}
