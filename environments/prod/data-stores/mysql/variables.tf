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