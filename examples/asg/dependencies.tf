data "aws_vpc" "default" {
    count = var.subnet_ids == null ? 1 : 0

    default = true
}

# The subnets from the default VPC are good enough for testing the ASG module.
data "aws_subnet_ids" "default" {
    count = var.subnet_ids == null ? 1 : 0

    vpc_id = data.aws_vpc.default[0].id
}