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

module "mysql" {
   source = "../../../../modules/data-stores/mysql"
  
  region                  = var.region
  environment             = "stage"
  
  vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
  vpc_remote_state_key    = "environments/stage/vpc/terraform.tfstate"
  
  instance_class          = "db.t3.small"
  allocated_storage_gb    = 150

  db_name                 = var.db_name
  db_username             = var.db_username 
  db_password             = var.db_password
}