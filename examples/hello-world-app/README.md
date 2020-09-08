# HELLO-WORLD-APP example

This folder contains a Terraform configuration that shows an example of how to use the [hello-world-app module](../../modules/services/hello-world-app) to deploy a sample web app based on an Auto Scaling Group and fronted by an Application Load Balancer in an Amazon Web Services (AWS) account.

This particular example uses the [default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html) in the [AWS region](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/) to deploy the ASG in which in effect makes the EC2 instances public. However, if you feed private subnet IDs of a custom VPC in the `subnet_ids` variable it will make your ASG private.

The default value provided for the `mysql_config` variable allows for mocking the MySQL database. Check out the [dev environment](../../environments/dev/services/hello-world-app) for an example of how to connect to a custom MySQL database.
## Pre-requisites

* [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* Terraform 0.12 or later installed on your computer. Check out HasiCorp [documentation](https://learn.hashicorp.com/terraform/azure/install) on how to install Terraform.

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

Clean up when you're done:

```
$ terraform destroy
```