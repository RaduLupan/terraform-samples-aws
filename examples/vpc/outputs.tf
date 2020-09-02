# VPC Id output from vpc module
output "vpc_id" {
    description = "The ID of the VPC"
    value       = module.vpc.vpc_id
}

# The first public subnet is used in the Terratest test file to verify that 
# the public subnet is indeed public (there is a rule in its route table with an "igw-" target).
output "public_subnet_id" {
    description = "The ID of the first public subnet"
    value       = module.vpc.public_subnet_id
}

# The first private subnet is used in the Terratest test file to verify that 
# the private subnet is indeed private (there is NO rule in its route table with an "igw-" target).
output "private_subnet_id" {
    description = "The ID of the first private subnet"
    value       = module.vpc.private_subnet_id
}