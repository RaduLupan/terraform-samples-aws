variable "db_remote_state_bucket" {
    description = "The name of the S3 bucket for the MySQL DB remote state"
    type        = string
    default     = null
}

variable "db_remote_state_key" {
    description = "The path for the DB's remote state in S3"
    type        = string
    default     = null
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

variable "server_text" {
    description = "The text the web server should return"
    type        = string 
    default     = "Hello, World"
}