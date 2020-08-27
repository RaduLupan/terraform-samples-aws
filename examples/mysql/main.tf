terraform {
  required_version = ">= 0.12, < 0.13" 
}

provider "aws" {
    version = "~> 2.0"
    region  = var.region
}

module "mysql" {
    source = "../../modules/data-stores/mysql"
    
    region                  = var.region
    environment             = var.environment
    db_name                 = "exampledb"
    db_password             = "DontLeaveMeInPlainText!"
    subnet_ids              = data.aws_subnet_ids.default.ids
}