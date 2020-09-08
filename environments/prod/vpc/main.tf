terraform {
  required_version = ">= 0.12, < 0.13"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file. 
  # via terraform init -backend-config ../../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "environments/prod/vpc/terraform.tfstate"
  }
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "vpc" {
    
    # Github source - public repository. Note that the double-slash in the Git URL after the repository name is required.
    # Also, the v0.0.3 tag had to be pushed using:
    # git tag -a "v0.0.3" -m "First release"
    # git push --follow-tags

    source = "github.com/RaduLupan/terraform-samples-aws//modules/vpc?ref=v0.0.3"
    
    
    region      = var.region
    vpcCidr     = "10.30.0.0/16"
    environment = "prod"
}