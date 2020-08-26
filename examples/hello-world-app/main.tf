terraform {
  required_version = ">= 0.12, < 0.13" 
}

provider "aws" {
    version = "~> 2.0"
    region  = "us-east-2"
}

module "hello_world_app" {
    source = "../../modules/services/hello-world-app"
    
    region                  = var.region
    environment             = var.environment
       
    min_size                = 2
    max_size                = 10
    enable_autoscaling      = false

    vpc_id                  = data.aws_vpc.default.id 
    public_subnet_ids       = data.aws_subnet_ids.default.ids
    private_subnet_ids      = data.aws_subnet_ids.default.ids

    mysql_config            = var.mysql_config

    custom_tags = {
        owner      ="devops"
        deployedby = "terraform"
    }
    
    ami                     = "ami-0a63f96e85105c6d3"
    server_text             = "Hello, World!"  
}