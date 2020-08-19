terraform {
  required_version = ">= 0.12, < 0.13" 
}

provider "aws" {
    version = "~> 2.0"
    region  = "us-east-2"
}

module "hello-world-app" {
    source = "../../modules/services/hello-world-app"
    
    region                  = var.region
    environment             = "dev"
    cluster_name            = "terraform-web"
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/dev/vpc/terraform.tfstate"
    db_remote_state_bucket  = "terraform-state-dev-us-east-2-fkaymsvstthc"
    db_remote_state_key     = "environments/dev/data-stores/mysql/terraform.tfstate"
    instance_type           = "t3.micro"
    min_size                = 2
    max_size                = 10
    server_port             = 8080
    custom_tags = {
        owner      ="devops"
        deployedby = "terraform"
    }
    enable_autoscaling      = false
    ami                     = "ami-0a63f96e85105c6d3"
    server_text             = "Hello, World!"  
}