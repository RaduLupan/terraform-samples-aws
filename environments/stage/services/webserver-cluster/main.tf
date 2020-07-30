terraform {
  required_version = ">= 0.12, < 0.13"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file 
  # via terraform init -backend-config ../../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "environments/stage/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "webserver-cluster" {
    # Local source
    source = "../../../../modules/services/webserver-cluster"
    
    # Github source - public repository. Note that the double-slash in the Git URL after the repository name is required.
    # Also, the v0.0.1 tag had to be pushed using:
    # git tag -a "v0.0.1" -m "First release"
    # git push --follow-tags
    # source = "github.com/RaduLupan/terraform-samples-aws//modules/services/webserver-cluster?ref=v0.0.3"
  
    region                  = var.region
    environment             = "stage"
    cluster_name            = "terraform-web"
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/stage/vpc/terraform.tfstate"
    db_remote_state_bucket  = "terraform-state-dev-us-east-2-fkaymsvstthc"
    db_remote_state_key     = "environments/stage/data-stores/mysql/terraform.tfstate"
    instance_type           = "t3.micro"
    min_size                = 2
    max_size                = 10
    server_port             = 8080
    enable_autoscaling      = false
    custom_tags = {
        owner      ="devops"
        deployedby = "terraform"
    }
}