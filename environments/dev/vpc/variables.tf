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

variable "vpcCidr" {
    description = "VPC CIDR Block"
    type        = string
    default = "10.10.0.0/16"
}
