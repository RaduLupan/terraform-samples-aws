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

module "webserver-cluster" {
        
    # Github source - public repository. Note that the double-slash in the Git URL after the repository name is required.
    # Also, the v0.0.3 tag had to be pushed using:
    # git tag -a "v0.0.3" -m "First release"
    # git push --follow-tags
    source = "github.com/RaduLupan/terraform-samples-aws//modules/services/webserver-cluster?ref=v0.0.3"
  
    region                  = var.region
    environment             = "prod"
        
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/prod/vpc/terraform.tfstate"
    
    db_remote_state_bucket  = "terraform-state-dev-us-east-2-fkaymsvstthc"
    db_remote_state_key     = "environments/prod/data-stores/mysql/terraform.tfstate"
    
    cluster_name            = "terraform-web"
    instance_type           = "t3.large"
    min_size                = 2
    max_size                = 10
    server_port             = 8080
    enable_autoscaling      = false
    custom_tags = {
        owner      ="devops"
        deployedby = "terraform"
    }
}