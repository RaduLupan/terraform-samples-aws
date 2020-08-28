# Database endpoint output from mysql module
output "address" {
    description = "Database endpoint"
    value       = module.mysql.address
}

# The port output from mysql module
output "port" {
    description = "The port the database is listening on"
    value       = module.mysql.port
}