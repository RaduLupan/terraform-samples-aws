# ALB module

This folder contains a Terraform configuration that defines a module for deploying an [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) (ALB) in an Amazon Web Services (AWS) account.

* If the subnet_ids variable is set to null, the ALB will be deployed on the [default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html) in the current [AWS region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html), which makes the ALB Internet-facing (public).  
* If the subnet_ids variable is pointing to public subnet IDs in a custom VPC then the ALB will be Internet-facing (public).
* If the subnet_ids variable is pointing to private subnet IDs in a custom VPC then the ALB will be internal (private).

## Quick start

Terraform modules are not meant to be deployed directly. Instead, they are invoked from within other Terraform configurations. 
* See [examples/alb](../../../examples/alb) for example on how to invoke the ALB module.
