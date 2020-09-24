terraform {
    required_version = ">= 0.12, < 0.13"

    backend "s3" {  
        
        # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
        # manually, uncomment and fill in the config below.

        # bucket         = "<YOUR S3 BUCKET>"       
        # key            = "<SOME PATH>/terraform.tfstate"
        # region         = "<YOUR S3 BUCKET REGION>"  
        # dynamodb_table = "<YOUR DYNAMODB TABLE>"       
        # encrypt        = true
    }
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "hello-world-app" {
    source = "../../../../modules/services/hello-world-app"
    
    region                  = var.region
    environment             = var.environment
    cluster_name            = "terraform-web"
    
    vpc_remote_state_bucket = var.vpc_remote_state_bucket
    vpc_remote_state_key    = var.vpc_remote_state_key
    
    db_remote_state_bucket  = var.db_remote_state_bucket
    db_remote_state_key     = var.db_remote_state_key
    
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
    server_text             = "Hello from App v2!"  
}