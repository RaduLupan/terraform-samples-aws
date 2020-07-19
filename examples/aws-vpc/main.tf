terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "terraform-state-dev-us-east-2-fkaymsvstthc"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks-dev-us-east-2"
    encrypt        = true
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
    Name = "vpc-${local.project}-${var.environment}-${var.region}"
    environment = var.environment
  }
}

