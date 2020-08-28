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
    db_name                 = var.db_name
    db_username             = var.db_username
    db_password             = var.db_password
    subnet_ids              = data.aws_subnet_ids.default.ids
}