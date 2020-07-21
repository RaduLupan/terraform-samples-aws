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