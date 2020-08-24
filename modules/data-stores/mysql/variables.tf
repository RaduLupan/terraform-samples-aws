variable "region" {
    description = "AWS Region"
    type        = string
}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "vpc_remote_state_bucket" {
    description = "The name of the S3 bucket for the VPC's remote state"
    type        = string
}

variable "vpc_remote_state_key" {
    description = "The path for the VPC's remote state in S3"
    type        = string
}

variable "instance_class" {
    description = "The class of RDS instance i.e. db.t2.micro"
    type        = string
}

variable "allocated_storage_gb" {
    description = "The allocated storage for the RDS instance in GB"
    type        = number
}

variable "db_name" {
    description = "The name to use for the database"
    type        = string
}

variable "db_password" {
    description = "The admin password for the database"
    type        = string
}
