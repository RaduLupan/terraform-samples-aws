# Use this data source to get the VPC Id output from the remote state file of the vpc module.
data "terraform_remote_state" "vpc" {
    # If var.vpc_id has a non-null value that means that an existing VPC is being used so no need to construct the data source. 
    count = var.vpc_id == null ? 1 : 0

    backend = "s3"

    config = {
        bucket = var.vpc_remote_state_bucket
        key    = var.vpc_remote_state_key
        region = var.region
    }
}

# Use this data source to get the db-endpoint and port outputs from the remote state file of the mysql module.
data "terraform_remote_state" "db" {
    # If var.mysql_config has a non-null value that means that the database is being mocked (simulated) so no need to construct the data source. 
    count = var.mysql_config == null ? 1 : 0

    backend = "s3"

    config = {
        bucket = var.db_remote_state_bucket
        key    = var.db_remote_state_key
        region = var.region
    }
}

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=private
data "aws_subnet_ids" "private_subnet" {
  # If var.private_subnet_ids has a non-null value that means that existing subnets are being used so no need to construct the data source.
  count = var.private_subnet_ids == null ? 1 : 0

  vpc_id = local.vpc_id

  tags = {
    tier = "private"
  }
}

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=public.
data "aws_subnet_ids" "public_subnet" {
  # If var.public_subnet_ids has a non-null value that means that existing subnets are being used so no need to construct the data source.
  count = var.public_subnet_ids == null ? 1 : 0
  
  vpc_id = local.vpc_id

  tags = {
    tier = "public"
  }
}