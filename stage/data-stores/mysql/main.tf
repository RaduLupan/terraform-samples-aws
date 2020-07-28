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
  # Local source.
  # source = "../../../modules/data-stores/mysql"
  
  # Github source - public repository. Note that the double-slash in the Git URL is required.
  source = "github.com/RaduLupan/terraform-samples-aws/modules/services//webserver-cluster?ref=v0.0.1"
  
  region                  = var.region
  environment             = "stage"
  vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
  vpc_remote_state_key    = "stage/vpc/terraform.tfstate"
  instance_class          = "db.t2.micro"
  allocated_storage_gb    = 10
  db_name                 = "webdb"
  db_password             = "DontLeaveMeInClearText!" 
}