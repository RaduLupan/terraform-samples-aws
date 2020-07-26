variable "region" {
    description = "AWS Region"
    type        = string

}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "vpc_id" {
    description = "The VPC ID for the VPC where the auto scaling group will be deployed"
    type        = string
}

variable "db_password" {
    description = "The admin password for the database"
    type        = string
}
