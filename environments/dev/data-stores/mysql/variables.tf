variable "region" {
    description = "AWS Region"
    type        = string

}

variable "db_password" {
    description = "The admin password for the database"
    type        = string
}

variable "db_name" {
    description = "The name to use for the database"
    type        = string
    default     = "example_database_dev"
}