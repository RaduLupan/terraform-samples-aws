# VPC module

This folder contains an example Terraform configuration that deploys a custom Virtual Private Cloud (VPC) in an Amazon Web Services (AWS) account.
* The VPC will have one public subnet and one private subnet in each [Availability Zone](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/) (AZ) in the current AWS region. For example, if the current region has 3 AZs, the VPC will have 3 public subnets and 3 private subnets.
* The VPC [CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) IP range must be /16 and the module will use the Terraform [cidrsubnet](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html) function to calculate /24 CIDR addresses for all subnets. For example, if the vpcCidr is 10.0.0.0/16 and the current region has 3 AZs, the module will create: 
..*3 public subnets with the following CIDR addresses: 10.0.0.0/24, 10.0.1.0/24, and 10.0.2.0/24
..*3 private subnets with the following CIDR addresses: 10.0.3.0/24, 10.0.4.0/24, and 10.0.5.0/24

## Quick start

Terraform modules are not meant to be deployed directly. Instead, they are invoked from within other Terraform configurations. 
* See [environments/dev/networking/vpc](../../../environments/dev/networking/vpc) and [environments/stage/networking/vpc](../../../environments/stage/networking/vpc) for examples on how to invoke the VPC module from a local source.
* See [environments/prod/networking/vpc](../../..environments/prod/networking/vpc) for example on how to invoke the VPC module from a Github source.