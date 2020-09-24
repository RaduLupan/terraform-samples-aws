#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "region" {
    description = "AWS region"
    type        = string
    default    = "us-east-2"

}
variable "environment" {
    description = "Environment type i.e. dev, test, stage, prod"
    type        = string
    default     = "dev"
    
}

