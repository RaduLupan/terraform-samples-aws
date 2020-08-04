terraform {
  required_version = ">= 0.12, < 0.13"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file. 
  # via terraform init -backend-config ../../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "environments/dev/cluster/asg-rolling-deploy/terraform.tfstate"
  }
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "asg" {
    source = "../../../../modules/cluster/asg-rolling-deploy"
   
    region                  = var.region
    environment             = "dev"
    cluster_name            = "terraform-web"
    ami                     = "ami-0a63f96e85105c6d3" 
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/stage/vpc/terraform.tfstate"
    instance_type           = "t3.micro"
    min_size                = 2
    max_size                = 10
    enable_autoscaling      = false
    custom_tags = {
        owner      ="devops"
        deployedby = "terraform"
    }
}