terraform {
  required_version = ">= 0.12, < 0.13" 
}

provider "aws" {
    version = "~> 2.0"
    region  = "us-east-2"
}

module "alb" {
    source = "../../modules/networking/alb"
    
    environment             = "dev"
    alb_name                = var.alb_name
    
    # Uses the subnet_ids for the default VPC. For a custom VPC simply list the subnet IDs like that subnet_ids = ["subnet_id_1","subnet_id_2"].
    subnet_ids              = data.aws_subnet_ids.default[0].ids
    
}