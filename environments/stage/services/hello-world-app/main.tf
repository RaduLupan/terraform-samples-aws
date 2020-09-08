terraform {
  required_version = ">= 0.12, < 0.13"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file 
  # via terraform init -backend-config ../../../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "environments/stage/services/hello-world-app/terraform.tfstate"
  }
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "hello-world-app" {
    source = "../../../../modules/services/hello-world-app"
    
    region                  = var.region
    environment             = "stage"
    cluster_name            = "terraform-web"
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/stage/vpc/terraform.tfstate"
    db_remote_state_bucket  = "terraform-state-dev-us-east-2-fkaymsvstthc"
    db_remote_state_key     = "environments/stage/data-stores/mysql/terraform.tfstate"
    instance_type           = "t3.small"
    min_size                = 2
    max_size                = 10
    server_port             = 8080
    custom_tags = {
        owner      ="devops"
        deployedby = "terraform"
    }
    enable_autoscaling      = false
    ami                     = "ami-0a63f96e85105c6d3"
    server_text             = "Hello from App v1!"  
}