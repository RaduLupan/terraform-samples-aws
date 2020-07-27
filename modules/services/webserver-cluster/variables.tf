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

variable "db_remote_state_bucket" {
    description = "The name of the S3 bucket for the MySQL DB remote state"
    type        = string
}

variable "db_remote_state_key" {
    description = "The path for the DB's remote state in S3"
    type        = string
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
}

variable "server_port" {
    description = "Internal server port for HTTP"
    type        = number
}