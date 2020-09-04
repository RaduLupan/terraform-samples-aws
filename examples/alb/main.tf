terraform {
  required_version = ">= 0.12, < 0.13" 
}

provider "aws" {
    version = "~> 2.0"
    region  = "us-east-2"
}

# Calculated local values. 
locals {

    # The subnet IDs are either extracted from the default VPC or specified in var.subnet_ids variable.
    subnet_ids = (var.subnet_ids == null ? 
                 data.aws_subnet_ids.default[0].ids : var.subnet_ids            
    )
}

module "alb" {
    source = "../../modules/networking/alb"
    
    environment             = "dev"
    alb_name                = var.alb_name
    
    subnet_ids              = local.subnet_ids
    
}