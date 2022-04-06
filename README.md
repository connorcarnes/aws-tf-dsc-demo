# Branch demo-00 Overview

Contains simple Terraform config that uses a local backend and creates a VPC.

Steps below assume you already have Terraform installed and configured to use with an AWS account.

## [Terraform Settings Block](https://www.terraform.io/language/settings#terraform-settings)

## [Provider Block](https://www.terraform.io/language/providers)

## [Resource Blocks](https://www.terraform.io/language/resources/syntax)

### [Resource Naming](https://www.terraform-best-practices.com/naming)

## [Terraform Docs - aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

# Deploy

Navigate to `terraform` directory and follow steps below.

## [terraform init](https://www.terraform.io/cli/commands/init)

```
C:\code\aws-tf-dsc-demo\terraform> terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v4.8.0...
- Installed hashicorp/aws v4.8.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

## [terraform plan](https://www.terraform.io/cli/commands/plan)

```
C:\code\aws-tf-dsc-demo\terraform> terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.this will be created
  + resource "aws_vpc" "this" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "my_vpc"
        }
      + tags_all                             = {
          + "Environment" = "tf-lab"
          + "Name"        = "my_vpc"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

## [terraform apply](https://www.terraform.io/cli/commands/apply)

This will output a plan just like above but also prompt you to type yes/no to approve.

```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.this: Creating...
aws_vpc.this: Still creating... [10s elapsed]
aws_vpc.this: Creation complete after 12s [id=vpc-0063f3c627a9faab2]
```

## [terraform state command](https://www.terraform.io/cli/commands/state)

```
terraform state list
aws_vpc.this
```

## [terraform console command](https://www.terraform.io/cli/commands/console)

```
C:\code\aws-tf-dsc-demo\terraform> terraform console
> aws_vpc.this
{
  "arn" = "arn:aws:ec2:us-east-1:514215195183:vpc/vpc-0063f3c627a9faab2"
  "assign_generated_ipv6_cidr_block" = false
  "cidr_block" = "10.0.0.0/16"
  "default_network_acl_id" = "acl-06de7d50f223109c2"
  "default_route_table_id" = "rtb-0c5efe094b1307a8e"
  "default_security_group_id" = "sg-05c9bc53d0143253f"
  "dhcp_options_id" = "dopt-0385a20739dc4fa23"
  "enable_classiclink" = false
  "enable_classiclink_dns_support" = false
  "enable_dns_hostnames" = true
  "enable_dns_support" = true
  "id" = "vpc-0063f3c627a9faab2"
  "instance_tenancy" = "default"
  "ipv4_ipam_pool_id" = tostring(null)
  "ipv4_netmask_length" = tonumber(null)
  "ipv6_association_id" = ""
  "ipv6_cidr_block" = ""
  "ipv6_cidr_block_network_border_group" = ""
  "ipv6_ipam_pool_id" = ""
  "ipv6_netmask_length" = 0
  "main_route_table_id" = "rtb-0c5efe094b1307a8e"
  "owner_id" = "514215195183"
  "tags" = tomap({
    "Name" = "my_vpc"
  })
  "tags_all" = tomap({
    "Environment" = "tf-lab"
    "Name" = "my_vpc"
  })
}
> exit
 C:\code\aws-tf-dsc-demo\terraform>
```

# Destroy

## [terraform destroy](https://www.terraform.io/cli/commands/destroy)

```
C:\code\aws-tf-dsc-demo\terraform>
 [demo-00]terraform destroy
aws_vpc.this: Refreshing state... [id=vpc-0063f3c627a9faab2]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_vpc.this will be destroyed
  - resource "aws_vpc" "this" {
      - arn                              = "arn:aws:ec2:us-east-1:514215195183:vpc/vpc-0063f3c627a9faab2" -> null
      - assign_generated_ipv6_cidr_block = false -> null
      - cidr_block                       = "10.0.0.0/16" -> null
      - default_network_acl_id           = "acl-06de7d50f223109c2" -> null
      - default_route_table_id           = "rtb-0c5efe094b1307a8e" -> null
      - default_security_group_id        = "sg-05c9bc53d0143253f" -> null
      - dhcp_options_id                  = "dopt-0385a20739dc4fa23" -> null
      - enable_classiclink               = false -> null
      - enable_classiclink_dns_support   = false -> null
      - enable_dns_hostnames             = true -> null
      - enable_dns_support               = true -> null
      - id                               = "vpc-0063f3c627a9faab2" -> null
      - instance_tenancy                 = "default" -> null
      - ipv6_netmask_length              = 0 -> null
      - main_route_table_id              = "rtb-0c5efe094b1307a8e" -> null
      - owner_id                         = "514215195183" -> null
      - tags                             = {
          - "Name" = "my_vpc"
        } -> null
      - tags_all                         = {
          - "Environment" = "tf-lab"
          - "Name"        = "my_vpc"
        } -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_vpc.this: Destroying... [id=vpc-0063f3c627a9faab2]
aws_vpc.this: Destruction complete after 1s
```