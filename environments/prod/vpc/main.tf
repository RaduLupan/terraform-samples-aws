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