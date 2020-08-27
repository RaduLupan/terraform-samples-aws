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
    subnet_ids              = data.aws_subnet_ids.default.ids
}