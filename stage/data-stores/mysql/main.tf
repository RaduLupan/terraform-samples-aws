terraform {
    required_version = ">= 0.12"

    # Partial configuration.  
    # terraform init -backend-config ../../../backend.hcl will initialize the remote backend.
    backend "s3" {  
        key            = "stage/data-stores/mysql/terraform.tfstate"
    }
}
provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  region                  = var.region
  environment             = "stage"
  vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
  vpc_remote_state_key    = "stage/vpc/terraform.tfstate"
  db_password             = "DontLeaveMeInClearText!" 
}