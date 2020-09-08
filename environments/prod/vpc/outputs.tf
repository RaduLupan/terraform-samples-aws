# VPC Id output from vpc module
output "vpc-id" {
    description = "The ID of the VPC"
    value       = module.vpc.vpc-id
}
