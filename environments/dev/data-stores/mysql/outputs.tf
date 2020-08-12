# Database endpoint output from mysql module
output "db-endpoint" {
    value = module.mysql.db-endpoint
}

# The port output from mysql module
output "port" {
    value = module.mysql.port
}