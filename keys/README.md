# Overview

[If you want to RDP to your windows instances you will need a key pair](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-key-pairs.html)

If you want Terraform to create the aws key pair resource for you, create the keys on your machine and add them to this folder. The `.gitignore` prevents `.pem` and `.pub` files from being managed by git.

* yourkey.pem
* yourkey.pub

[Terraform Docs - aws_key_pair resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)

[How to Generate SSH Key in Windows 10](https://phoenixnap.com/kb/generate-ssh-key-windows-10)

Note that this project also creates SSM associations as well, so you will have command line access to your instances through the Session Manager in the SSM console (except on domain controllers).