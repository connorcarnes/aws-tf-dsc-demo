# Overview

Builds on branch demo-01. Introduces modules and input variables.

The module introduced is named `core` and contains configuration for resources that don't change very often. Resources from modules introduced in subsequent steps rely on this module.

You will need to create a file named `terraform.tfvars` in your `terraform` directory.

You also need to create a key pair for your EC2 instances. See the `README.md` in the `keys` directory for instructions.

# Sample terraform.tfvars

```
project_name    = "example-project"
dsc_bucket_name = "my-bucket-name"
key_path        = ""../keys/yourkey.pub"
vpc_cidr        = "10.0.0.0/16"
subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
pdc_ip          = "10.0.1.10"
dns_ips         = ["1.1.1.1", "8.8.8.8"]
management_ips  = ["your-ip-here"] # If you want to RDP to your instances from your workstation
```

# [Standard Module Structure](https://www.terraform.io/language/modules/develop/structure)

Other files you may commonly see that aren't mentioned in the doc above are `providers.tf`,`versions.tf`,`backend.tf`,`data.tf` and `locals.tf`. You may also see different files for different services, e.g. `vpc.tf` and `s3.tf`.

# [Input Variables](https://www.terraform.io/language/values/variables)

Defining a variable in a module and using it in that same module is straightforward.

To pass a variable from the root module to a child module, both modules must have the variable defined in their `variables.tf` file. The value is passed from the root to the child in a module block:

```
module "core" {
  source       = "./modules/core"
  project_name = var.project_name
}
```
