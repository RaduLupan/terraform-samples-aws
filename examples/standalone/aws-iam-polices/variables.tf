#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"
}

variable "give_neo_cloudwatch_full_access" {
    description = "If true, neo gets full access to CloudWatch"
    type        = bool
    default     = false
}