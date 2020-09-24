#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"
}

variable "user_names" {
    description = "Create IAM users with these names"
    type        = list(string)
    default     =["neo","trinity","morpheus"]
}