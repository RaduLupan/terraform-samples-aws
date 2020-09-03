# MySQL example

This folder contains a Terraform configuration that shows an example of how to use the [mysql module](../../modules/data-stores/mysql) to deploy a MySQL instance using RDS service in an Amazon Web Services (AWS) account.
This particular example uses the default VPC in the region to deploy the RDS instance in which means that the MySQL endpoint is public. However, if you feed private subnet IDs of an existing VPC in the `subnet_ids` variable it will make your MySQL endpoint private.
See the dev environment for an example on how to create the MySQL instance as private endpoint in a custom VPC.

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
