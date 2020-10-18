# Simple VPC example using the VPC module in Terraform Registry
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-registry-example-vpc"

  cidr = "10.10.0.0/16"

  azs                 = ["us-east-2a", "us-east-2b"]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24"]
  
  single_nat_gateway = true
  enable_nat_gateway = true

  tags = {
    owner       = "infrastructure-team"
    environment = "dev"
    terraform   = "true"
  }
}
