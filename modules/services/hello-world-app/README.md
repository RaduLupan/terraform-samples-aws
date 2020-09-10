# Hello World App module

This folder contains an example Terraform configuration that defines a module for deploying a simple "Hello, World" application accross a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/)) and [Auto Scaling](https://aws.amazon.com/autoscaling)) in an Amazon Web Services (AWS) account.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, they are invoked from within other Terraform configurations. 
* See [environments/dev/services/hello-world-app](../../../environments/dev/services/hello-world-app) and [environments/stage/services/hello-world-app](../../../environments/stage/services/hello-world-app) for examples on how to invoke the Hello-World-App module from a local source.
* See [environments/prod/services/web-cluster](../../..environments/prod/services/web-cluster) for example on how to invoke the Hello-World-App module from a Github source.
