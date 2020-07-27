# This template deploys the following AWS resources:
# - 1 x RDS instance running MySQL in a private subnet

# Use this data source to get the VPC Id output from the remote state file of the vpc module.
data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
        bucket = var.vpc_remote_state_bucket
        key    = var.vpc_remote_state_key
        region = var.region
    }
}

# Calculated local values based on data sets.
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

# Deploys DB subnet group consisting of all the private subnets in the VPC.
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.aws_subnet_ids.private_subnet.ids

  tags = {
    Name        = "private-subnet-group"
    environment = var.environment
    terraform   = true
  }
}

# Deploys RDS instance running MySQL in the private subnet group.
resource "aws_db_instance" "db1" {
    identifier_prefix    = "terraform-samples"
    engine               = "mysql"
    allocated_storage    = var.allocated_storage_gb
    instance_class       = var.instance_class
    name                 = var.db_name
    username             = "awsadmin"
    password             = var.db_password
    db_subnet_group_name = aws_db_subnet_group.default.name
    skip_final_snapshot  = true
}