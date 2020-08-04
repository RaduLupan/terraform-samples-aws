terraform {
  required_version = ">= 0.12, < 0.13"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file. 
  # via terraform init -backend-config ../../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "environments/dev/networking/alb/terraform.tfstate"
  }
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "alb" {
    source = "../../../../modules/networking/alb"
   
    region                  = var.region
    environment             = "dev"
    alb_name                = "terraform-web-alb"
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/dev/vpc/terraform.tfstate"

}