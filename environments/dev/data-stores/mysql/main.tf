terraform {
    required_version = ">= 0.12, < 0.13"

    # Partial configuration.  
    # terraform init -backend-config ../../../../backend.hcl will initialize the remote backend.
    backend "s3" {  
        key            = "environments/dev/data-stores/mysql/terraform.tfstate"
    }
}
provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"
  
  region                  = var.region
  environment             = var.environment
  
  vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
  vpc_remote_state_key    = "environments/dev/vpc/terraform.tfstate"
  
  db_name                 = var.db_name
  db_username             = var.db_username 
  db_password             = var.db_password
}