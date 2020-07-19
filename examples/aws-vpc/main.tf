terraform {
  required_version = ">= 0.12"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file 
  # via terraform init -backend-config ../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "tf-samples-vpc/terraform.tfstate"
  }
}
provider "aws" {
    version = "2.70.0"
    region  = var.region
}

locals {
    project = "terraform-samples"
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpcCidr  
  instance_tenancy = "default"

  tags = {
    Name        = "vpc-${local.project}-${var.environment}-${var.region}"
    environment = var.environment
    terraform   = true
  }
}

