data "aws_vpc" "default" {
    default = true
}

# The subnets from the default VPC are good enough for testing the MySQL module.
data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}