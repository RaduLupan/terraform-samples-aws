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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-${local.project}-${var.environment}-${var.region}"
    environment = var.environment
    terraform   = true
  }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "rt-public-subnets-all"
    environment = var.environment
    terraform   = true
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  count = length(data.aws_availability_zones.available.names)
  
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "rt-private-subnets-${data.aws_availability_zones.available.names[count.index]}"
    environment = var.environment
    terraform   = true
  }
}

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

# Deploys 1 x EIP in each availability zone to be attached to the NAT Gateway
resource "aws_eip" "eip_natgw" {
  count = length(data.aws_availability_zones.available.names)
  vpc      = true

  tags = {
    Name        = "eip-natgw-${data.aws_availability_zones.available.names[count.index]}"
    environment = var.environment
    terraform   = true
  }
}

# Deploys 1 x NATGW in each public subnet.
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

