# Database endpoint output from mysql module
output "db-endpoint" {
    description = "Database endpoint"
    value       = module.mysql.db-endpoint
}

# The port output from mysql module
output "port" {
    description = "The port the database is listening on"
    value       = module.mysql.port
}