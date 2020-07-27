data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
        bucket = var.vpc_remote_state_bucket
        key    = var.vpc_remote_state_key
        region = var.region
    }
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc-id
}

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=private
data "aws_subnet_ids" "private_subnet" {
  vpc_id = local.vpc_id

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