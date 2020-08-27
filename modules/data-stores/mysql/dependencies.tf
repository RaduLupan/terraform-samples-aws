# Use this data source to get the VPC Id output from the remote state file of the vpc module.
data "terraform_remote_state" "vpc" {
    count = var.subnet_ids == null ? 1 : 0

    backend = "s3"

    config = {
        bucket = var.vpc_remote_state_bucket
        key    = var.vpc_remote_state_key
        region = var.region
    }
}

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=private
data "aws_subnet_ids" "private_subnet" {
  count = var.subnet_ids == null ? 1 : 0
  
  vpc_id = local.vpc_id

  tags = {
    tier = "private"
  }
}

# If subnet_ids are provided use this data source to extract the vpc_id
data "aws_subnet" "selected" {
  count = var.subnet_ids == null ? 0 : 1

  id = var.subnet_ids[0]
}