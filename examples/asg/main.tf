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

module "asg" {
    source = "../../modules/cluster/asg-rolling-deploy"
    
    region                  = var.region
    environment             = "dev"

    cluster_name            = var.cluster_name
    
    ami                     = "ami-0bbe28eb2173f6167"    
    instance_type           = "t3.micro"
    
    min_size                = 1
    max_size                = 1 
    enable_autoscaling      = false
    
    subnet_ids              = local.subnet_ids
}