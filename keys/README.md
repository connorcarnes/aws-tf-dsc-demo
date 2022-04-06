# Overview

[If you want to RDP to your windows instances you will need a key pair](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-key-pairs.html)

Create the keys on your machine and add them to this folder. The `.gitignore` prevents `.pem` and `.pub` files from being managed by git (make sure the file extensions are present)

* yourkey.pem
* yourkey.pub

# Notes

* [Terraform Docs - aws_key_pair resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
* [How to Generate SSH Key in Windows 10](https://phoenixnap.com/kb/generate-ssh-key-windows-10)
* This project also creates SSM associations, so you will have command line access to your instances through the Session Manager in the SSM console (except on domain controllers).
* Amazon EC2 supports 2048-bit SSH-2 RSA keys for Windows instances.
* Ensure the `.pem` and `.pub` file extensions are present, add them manually if needed.