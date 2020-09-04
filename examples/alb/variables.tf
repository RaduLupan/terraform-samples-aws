#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "alb_name" {
    description = "The name of the ALB and all its resources"
    type        = string
    default     = "terraform-samples"
}

variable "subnet_ids" {
    description = "The IDs for subnets that the ALB sits on"
    type        = list(string)
    default     = null  
}

