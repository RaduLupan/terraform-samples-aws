# This template deploys the following AWS resources:
# - 1 x RDS instance running MySQL in a private subnet

# Calculated local values based on data sets.
locals {
  vpc_id = (
    var.subnet_ids == null
      ? data.terraform_remote_state.vpc[0].outputs.vpc_id
      : data.aws_subnet.selected[0].vpc_id
  )
  subnet_ids = (
    var.subnet_ids == null
      ? data.aws_subnet_ids.private_subnet[0].ids
      : var.subnet_ids
  )

}

# Deploys DB subnet group consisting of all the private subnets in the VPC.
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = local.subnet_ids

  tags = {
    Name        = "db-subnet-group"
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
    username             = var.db_username
    password             = var.db_password
    db_subnet_group_name = aws_db_subnet_group.default.name
    skip_final_snapshot  = true
}