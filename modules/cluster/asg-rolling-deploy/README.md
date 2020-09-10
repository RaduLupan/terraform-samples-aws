# Auto Scaling Group with Rolling Deploy module

This folder contains an example Terraform configuration that defines a module for deploying a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) and [Auto 
Scaling](https://aws.amazon.com/autoscaling/)) in an Amazon Web Services (AWS) account.

The Auto Scaling Group (ASG) uses the zero-downtime deployment technique described [here](https://groups.google.com/g/terraform-tool/c/7Gdhv1OAc80/m/iNQ93riiLwAJ?pli=1). 

## Quick start

Terraform modules are not meant to be deployed directly. Instead, they are invoked from within other Terraform configurations. 
* See [examples/asg](../../../examples/asg) for example on how to invoke the ASG module.