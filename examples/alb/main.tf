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
    subnet_ids              = ["subnet-0234a4b505208cadb","subnet-0367ba8cb809f1c87"]
}