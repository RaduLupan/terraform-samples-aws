variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"
}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
    default       = "dev"
}

variable "db_password" {
    description = "The admin password for the database"
    type        = string
}

variable "db_name" {
    description = "The name to use for the database"
    type        = string
}