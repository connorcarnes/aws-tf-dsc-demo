# Overview

Builds on example from branch demo-00. Adds remote S3 backend for terraform. Before starting, open a fresh PowerShell session and delete following from your local directory if they're present:

- `.terraform` directory and it's contents
- any `.tfstate` and `.terraform.lock.hcl` files present

The steps for deploying and destroying are the same as in the previous step.

The main difference this branch provides is that your state file is now in an S3 bucket. This is good because:

- S3 is resilient storage, safer than your local disk
- Your state is now in a central location, allowing other developers to contribute
- The S3 backend for Terraform supports state locking, meaning only one thread can make changes to the state at a time.

# [About remote S3 backend for terraform](https://www.terraform.io/language/settings/backends/s3)

# Bootstrapping S3 backend with CloudFormation

Deploy the `\cloudformation\terraform_backend_setup.yml` CloudFormation template through the AWS console or CLI to bootstrap the backend.

[If needed, see this tutorial on how to deploy a CloudFormation template.](https://www.wellarchitectedlabs.com/reliability/200_labs/200_deploy_and_update_cloudformation/1_deploy_infra/)

Once deployed, select the stack in the CloudFormation console and go to the Outputs tab. Input the values in the Terraform settings block in `main.tf`:

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = <YOUR_BUCKET>
    key            = "tf-lab.tfstate"
    region         = <YOUR_REGION>
    dynamodb_table = <YOUR_DDB>
  }
}
```