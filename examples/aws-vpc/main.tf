# This template deploys the following resources in AWS:
# 1 x VPC with 1 x public subnet and 1 x private subnet in each availability zone in the region
# 1 x Internet Gateway attached to the VPC
# 1 x NAT Gateway with Elastic IP in each availability zone in the region
# 1 x Route Table for all public subnets with default route pointing to IGW
# 1 x Route Table for each private subnet with default route pointing to NAT Gateway

terraform {
  required_version = ">= 0.12"
  
  # Partial configuration. The other arguments i.e. bucket, region, will be passed in from backend.hcl file 
  # via terraform init -backend-config ../../backend.hcl.
  # Variables are not allowed in the backend block!
  backend "s3" {  
    key            = "tf-samples-vpc/terraform.tfstate"
  }
}
provider "aws" {
    version = "2.70.0"
    region  = var.region
}

locals {
    project = "terraform-samples"

}

resource "aws_vpc" "main" {
  cidr_block       = var.vpcCidr
  instance_tenancy = "default"

  tags = {
    Name        = "vpc-${local.project}-${var.environment}-${var.region}"
    environment = var.environment
    terraform   = true
  }
}

# Data source that gets all availability zones in the current region.
data "aws_availability_zones" "available" {
  state = "available"
}

# Deploys 1 x public subnet in each availability zone.
resource "aws_subnet" "public_subnet" {
  # The number of availability zones in the current region.
  count = length(data.aws_availability_zones.available.names)
  
  vpc_id = aws_vpc.main.id
  # cidrsubnet() function creates a Cidr address in the VpcCidr https://www.terraform.io/docs/configuration/functions/cidrsubnet.html.
  # Assumes that the vpcCidr is /16 and by adding 8 bits to the network ID it creates /24 subnets.
  cidr_block = cidrsubnet(var.vpcCidr,8,count.index)
  availability_zone = data.aws_availability_zones.available.names["${count.index}"]
  map_public_ip_on_launch = true
  tags = {
    Name        = "public-${cidrsubnet(var.vpcCidr,8,count.index)}"
    environment = var.environment
    terraform   = true
  }
}

# Deploys 1 x private subnet in each availability zone.
resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)
  
  vpc_id = aws_vpc.main.id
  # Makes sure it skips the public subnet Cidrs so they do not overlap.
  cidr_block = cidrsubnet(var.vpcCidr,8,(count.index+length(data.aws_availability_zones.available.names)))
  availability_zone = data.aws_availability_zones.available.names["${count.index}"]
  map_public_ip_on_launch = false
  tags = {
    Name        = "private-${cidrsubnet(var.vpcCidr,8,(count.index+length(data.aws_availability_zones.available.names)))}"
    environment = var.environment
    terraform   = true

  }
}

# Deploys Internet Gateway and attaches to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-${local.project}-${var.environment}-${var.region}"
    environment = var.environment
    terraform   = true
  }
}

# Deploys one route table for all public subnets
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "rt-public-subnets-all"
    environment = var.environment
    terraform   = true
  }
}

# Deploys array of route tables: one for each private subnet
resource "aws_route_table" "private_subnet_route_table" {
  count = length(data.aws_availability_zones.available.names)
  
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "rt-private-subnets-${data.aws_availability_zones.available.names[count.index]}"
    environment = var.environment
    terraform   = true
  }
}

# Deploys default route in the public route table pointing to the Internet Gateway
resource "aws_route" "route_public" {
  route_table_id            = aws_route_table.public_subnet_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
  depends_on                = [aws_route_table.public_subnet_route_table]
}

# Associates all public subnets to the public-subnets-all route table.
resource "aws_route_table_association" "rta_public" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.public_subnet["${count.index}"].id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# Associates each private subnet to its route table in corresponding availability zone.
resource "aws_route_table_association" "rta_private" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.private_subnet["${count.index}"].id
  route_table_id = aws_route_table.private_subnet_route_table["${count.index}"].id
}

# Deploys 1 x Elastic IP in each availability zone to be attached to the NAT Gateway in that AZ.
resource "aws_eip" "eip_natgw" {
  count = length(data.aws_availability_zones.available.names)
  vpc      = true

  tags = {
    Name        = "eip-natgw-${data.aws_availability_zones.available.names[count.index]}"
    environment = var.environment
    terraform   = true
  }
}

# Deploys 1 x NAT Gateway in each public subnet and attaches the corresponding EIP to it.
resource "aws_nat_gateway" "natgw" {
  count = length(data.aws_availability_zones.available.names)
  
  allocation_id = aws_eip.eip_natgw["${count.index}"].id
  subnet_id     = aws_subnet.public_subnet["${count.index}"].id

  tags = {
    Name        = "natgw-${data.aws_availability_zones.available.names[count.index]}"
    environment = var.environment
    terraform   = true
  }
}

# Deploys default routes in all private route tables pointing the corresponding NAT Gateway.
resource "aws_route" "route_private" {
  count = length(data.aws_availability_zones.available.names)
  route_table_id            = aws_route_table.private_subnet_route_table["${count.index}"].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.natgw["${count.index}"].id
  depends_on                = [aws_route_table.private_subnet_route_table]
}