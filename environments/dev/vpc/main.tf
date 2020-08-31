terraform {
  required_version = ">= 0.12, < 0.13"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file. 
  # via terraform init -backend-config ../../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "environments/dev/vpc/terraform.tfstate"
  }
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "vpc" {
    source = "../../../modules/vpc"
   
    region      = var.region
    vpcCidr     = var.vpcCidr
    environment = var.environment
}