# Overview

Builds on branch demo-03. Introduces a third module, config.

# Addition to terraform.tfvars

```
ssm_parameters = {
  admin          = "examplepW@3"
  first-admin    = "examplepW@3"
  "regular.user" = "examplepW@3"
}
```

# [DSC - Write, Compile and Apply a Configuration](https://docs.microsoft.com/en-us/powershell/dsc/configurations/write-compile-apply-configuration?view=dsc-1.1)
# [DSC - ConfigurationData Parameter](https://docs.microsoft.com/en-us/powershell/dsc/configurations/configdata?view=dsc-1.1)

# [AWS Systems Manager State Manager - ApplyDSCMofs](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state-manager-using-mof-file.html)