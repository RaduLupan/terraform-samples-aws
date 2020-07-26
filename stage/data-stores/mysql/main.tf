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

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=private
data "aws_subnet_ids" "private_subnet" {
  vpc_id = var.vpc_id

  tags = {
    tier = "private"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.aws_subnet_ids.private_subnet.ids

  tags = {
    Name        = "private-subnet-group"
    environment = var.environment
    terraform   = true
  }
}

resource "aws_db_instance" "db1" {
    identifier_prefix    = "terraform-samples"
    engine               = "mysql"
    allocated_storage    = 10
    instance_class       = "db.t2.micro"
    name                 = "web_db"
    username             = "awsadmin"
    password             = var.db_password
    db_subnet_group_name = aws_db_subnet_group.default.name
}