output "db-endpoint" {
    description = "Database endpoint"
    value       = aws_db_instance.db1.address
}

output "port" {
    description = "The port the database is listening on"
    value = aws_db_instance.db1.port
}