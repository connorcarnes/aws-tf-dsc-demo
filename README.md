# Overview

Root Terraform module uses three custom modules (named core, comput and config) to deploy Windows EC2 instances on AWS and configure them using PowerShell DSC and AWS Systems Manager StateManager.

Core module deploys backend infrastructure that doesn't change often. For example, VPCs, Subnets, Security Groups, IAM resources and S3 buckets.

Compute module deploys EC2 instances and associated EBS volumes.

Config module creates AWS Systems Manager State Manager association with the instances using the AWS-ApplyDSCMofs document.

Keys directory is for storing key pairs you use for connecting to EC2 instances. The file extensions `.pem` and `.pub` are included in the `.gitignore`. See `README.md` in keys directory for details.

DSC directory is for storing DSC configurations and MOFs. The `.mof` file extension is included in the `.gitignore`.

There is a sample DSC configuration in the CorpDomain folder. It creates two mof files. At a high level one mof creates an Active Directory domain named corp.local and promotes the server to be DC. The other mof joins the server to corp.local.

You will need to compile the example MOFs on your machine so Terraform can upload them to AWS to be used by the instances. To do so:

- Open Windows PowerShel session
- Ensure you have the following DSC modules installed: ActiveDirectoryDsc, NetworkingDsc, ComputerManagementDsc, StorageDsc
- Navigate to the `/dsc/CorpDomain/` directory and run `./CorpDomain.ps1`. This should generate two MOFs in `/dsc/CorpDomain/CorpDomain/`.

## Sample .tfvars content

```
project_name    = "aws-tf-dsc-demo"
aws_region      = "us-east-1"
dsc_bucket_name = "my-aws-tf-dsc-demo-dsc-1234"
key_path        = "../keys/mykey.pub"
mof_directory   = "../dsc/CorpDomain/CorpDomain"
vpc_cidr        = "10.0.0.0/16"
subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
pdc_ip          = "10.0.1.10"
dns_ips         = ["1.1.1.1", "8.8.8.8"]
management_ips  = ["x.x.x.x/xx"]

ec2_data = {
  dc00 = {
    associate_public_ip_address = true
    instance_type               = "t2.small"
    private_ip                  = "10.0.1.10"
    az                          = "us-east-1a"
    data_disk_size              = 0
  },
  app00 = {
    associate_public_ip_address = true
    instance_type               = "t2.small"
    private_ip                  = "10.0.1.20"
    az                          = "us-east-1a"
    data_disk_size              = 1
  }
}

ssm_parameters = {
  admin          = "demopassworD!1"
  first-admin    = "demopassworD!1"
  "regular.user" = "demopassworD!1"
}

## Getting Started

See branches `demo-00 - demo-04`.
```