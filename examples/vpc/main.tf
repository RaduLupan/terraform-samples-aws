terraform {
  required_version = ">= 0.12, < 0.13"
 }

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "vpc" {
    source = "../../modules/networking/vpc"
   
    region      = var.region
    vpcCidr     = var.vpcCidr
    environment = var.environment
}