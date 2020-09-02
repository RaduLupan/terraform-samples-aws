output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.main.id
}

# The first public subnet is used in the Terratest test file to verify that 
# the public subnet is indeed public (there is a rule in its route table with an "igw-" target).
output "public_subnet_id" {
    description = "The ID of the first public subnet"
    value       = aws_subnet.public_subnet[0].id
}

# The first private subnet is used in the Terratest test file to verify that 
# the private subnet is indeed private (there is NO rule in its route table with an "igw-" target).
output "private_subnet_id" {
    description = "The ID of the first private subnet"
    value       = aws_subnet.private_subnet[0].id
}