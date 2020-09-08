terraform {
    required_version = ">= 0.12, < 0.13"

    # Partial configuration.  
    # terraform init -backend-config ../../../../backend.hcl will initialize the remote backend.
    backend "s3" {  
        key            = "environments/prod/data-stores/mysql/terraform.tfstate"
    }
}
provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "mysql" {
  # Github source - public repository. Note that the double-slash in the Git URL after the repository name is required.
  # Also, the v0.0.3 tag had to be pushed using:
  # git tag -a "v0.0.3" -m "First release"
  # git push --follow-tags

  source = "github.com/RaduLupan/terraform-samples-aws//modules/data-stores/mysql?ref=v0.0.3"
    
  region                  = var.region
  environment             = "prod"
  vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
  vpc_remote_state_key    = "environments/prod/vpc/terraform.tfstate"
  instance_class          = "db.t3.large"
  allocated_storage_gb    = 200
  db_name                 = "webdbadmin"
  db_password             = var.db_password
}