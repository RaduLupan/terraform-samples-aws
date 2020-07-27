provider "aws" {
    version = "2.70.0"
    region  = var.region
}

terraform {
  required_version = ">= 0.12"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file 
  # via terraform init -backend-config ../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "stage/services/webserver-cluster/terraform.tfstate"
  }
}

module "webserver-cluster" {
    source = "../../../modules/services/webserver-cluster"
    
    region                  = var.region
    environment             = "stage"
    cluster_name            = "terraform-web"
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "stage/vpc/terraform.tfstate"
    db_remote_state_bucket  = "terraform-state-dev-us-east-2-fkaymsvstthc"
    db_remote_state_key     = "stage/data-stores/mysql/terraform.tfstate"
    instance_type           = "t3.micro"
    min_size                = 2
    max_size                = 10
    server_port             = 8080
}