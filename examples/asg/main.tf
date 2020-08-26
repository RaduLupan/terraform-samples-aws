terraform {
  required_version = ">= 0.12, < 0.13" 
}

provider "aws" {
    version = "~> 2.0"
    region  = "us-east-2"
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
    
    subnet_ids              = data.aws_subnet_ids.default.ids
}