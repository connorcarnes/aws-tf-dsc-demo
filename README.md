# Overview

Builds on branch demo-02. Introduces a second module, and how to pass output from one module as input to another module.

# Addition to terraform.tfvars

```
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
```

# [Output Values](https://www.terraform.io/language/values/outputs)