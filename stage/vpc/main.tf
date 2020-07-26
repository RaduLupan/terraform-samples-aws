provider "aws" {
    version = "2.70.0"
    region  = var.region
}

terraform {
  required_version = ">= 0.12"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file 
  # via terraform init -backend-config ../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "stage/vpc/terraform.tfstate"
  }
}

module "vpc" {
    source = "../../modules/vpc"
    
    region      = var.region
    vpcCidr     = "10.10.0.0/16"
    environment = "stage"
}