# Hello-world app example - stage environment

This folder contains an example Terraform configuration that uses the [hello-world-app module](../../../../modules/services/hello-world-app) to deploy a simple "Hello, World" application accross a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/)) and [Auto Scaling](https://aws.amazon.com/autoscaling)) in an Amazon Web Services (AWS) account.

## Pre-requisites

* [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* Terraform 0.12 or later installed on your computer. Check out HasiCorp [documentation](https://learn.hashicorp.com/terraform/azure/install) on how to install Terraform.
* A Terraform remote backend consisting of 1 x S3 bucket to store the Terraform state and 1 x DynamoDB table to manage the locks. You can use [this](../../../../examples/standalone/tfstate-remote-backend-aws) example configuration to create the remote backend. Fill in the name of the S3 bucket and the name of the DynamoDB table in to the [`backend.hcl`](../../../../backend.hcl) file.
* A VPC tier deployed using [this](../../networking/vpc) configuration. The MySQL instance will be deployed on the private subnets of the custom VPC.
* A MySQL tier deployed using [this](../../data-stores/mysql) configuration. The ALB will be Internet-facing, sitting on the public subnets of the custom VPC and the EC2 instances behind the Auto Scaling Group will be sitting on the private subnets of the custom VPC.

Please note that this code was written for Terraform 0.12.x.

## Quick start

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
$ export AWS_ACCESS_KEY_ID=(your access key id)
$ export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Deploy the code:

```
$ terraform init
$ terraform apply
```

Clean up when you are done:

```
$ terraform destroy
```
