#----------------------------------------------------------------------------
# REQUIRED PARAMETERS: You must provide a value for each of these parameters.
#----------------------------------------------------------------------------

variable "region" {
    description = "AWS Region"
    type        = string
}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "db_name" {
    description = "The name to use for the database"
    type        = string
}

variable "db_username" {
    description = "The admin username for the database"
    type        = string
}

variable "db_password" {
    description = "The admin password for the database"
    type        = string
}

#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

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

variable "subnet_ids" {
    description = "The subnet IDs to deploy to"
    type        = list(string) 
    default     = null
}

variable "instance_class" {
    description = "The class of RDS instance i.e. db.t3.micro"
    type        = string
    default     = "db.t3.micro"
}

variable "allocated_storage_gb" {
    description = "The allocated storage for the RDS instance in GB"
    type        = number
    default     = 100
}
