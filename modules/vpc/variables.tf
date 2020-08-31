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

#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "vpcCidr" {
    description = "VPC CIDR Block"
    type        = string
    default = "10.0.0.0/16"
}
