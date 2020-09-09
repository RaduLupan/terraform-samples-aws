# MySQL module

This folder contains a Terraform configuration that defines a module for deploying a [managed MySQL instance](https://aws.amazon.com/rds/mysql/) in an Amazon Web Services (AWS) account.

* If the `subnet_ids` variable is set to null, the MySQL instance will be deployed on the [default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html) in the current [AWS region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html), which makes the MySQL instance endpoint public.  
* If the `subnet_ids` variable is pointing to public subnet IDs in a custom VPC then the MySQL instance endpoint will be public.
* If the `subnet_ids` variable is pointing to private subnet IDs in a custom VPC then MySQL instance endpoint will be private.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, they are invoked from within other Terraform configurations. 
* See [environments/dev/data-stores/mysql](../../../environments/dev/data-stores/mysql) and [environments/stage/data-stores/mysql](../../../environments/stage/data-stores/mysql) for examples on how to invoke the MySQL module from a local source.
* See [environments/prod/data-stores/mysql](../../..environments/prod/data-stores/mysql) for example on how to invoke the VPC module from a Github source.