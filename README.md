# terraform-samples-aws
I have created this repo while learning Terraform from the [Terraform Up & Running](https://www.terraformupandrunning.com/) book (which is a must read for anybody interested in Infrastructure as Code and Terraform, in my opinion). 

I have followed the code samples in the book building a "Hello, World" web app using an Auto Scaling Group of EC2 instances for the web tier and a managed MySQL database for the data tier. 

Unlike, in the book however, I do not deploy all resources in the [default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html), in public subnets. Instead, I have built a [VPC module](/modules/networking/vpc) that builds a custom VPC with public and private subnets so that the EC2 instances and the MySQL database are sitting on private subnets while only the [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) is Internet-facing. This addition makes the code more production-ready as it addresses the security concern of having resources publicly exposed.

## Quick start

If you haven't read the **Terraform Up & Running** book, you can still run the code of copurse. Make sure you consult the README in each folder for instructions.

## Resources
[Terraform Up and Running Code](https://github.com/brikis98/terraform-up-and-running-code)
[Terratest](https://github.com/gruntwork-io/terratest)