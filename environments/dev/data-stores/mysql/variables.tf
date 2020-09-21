#----------------------------------------------------------------------------
# REQUIRED PARAMETERS: You must provide a value for each of these parameters.
#----------------------------------------------------------------------------

variable "db_password" {
    description = "The admin password for the database"
    type        = string
}


#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

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

variable "db_name" {
    description = "The name to use for the database"
    type        = string
    default     = "example_database"
}

variable "db_username" {
    description = "The admin username for the database"
    type        = string
    default     = "admin"
}

variable "vpc_remote_state_bucket" {
    description = "The name of the S3 bucket for the VPC's remote state"
    type        = string
    default     = null
}

variable "vpc_remote_state_key" {
    description = "The path for the VPC's remote state in S3"
    type        = string
    default     = null
}