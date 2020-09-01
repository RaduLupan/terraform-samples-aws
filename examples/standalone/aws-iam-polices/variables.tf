variable "region" {
    description = "AWS Region"
    type        = string
}

variable "give_neo_cloudwatch_full_access" {
    description = "If true, neo gets full access to CloudWatch"
    type        = bool
    default     = false
}