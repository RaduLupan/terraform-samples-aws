variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"
}

variable "mysql_config" {
    description = "The config for the MySQL DB"

    type        = object({
        address = string
        port    = number
    })

    default     = {
        address = "simulated-mysql-db-endpoint"
        port    = 12345
    }
}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
    default       = "example"
}