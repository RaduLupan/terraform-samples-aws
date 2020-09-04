#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"
}

variable "cluster_name" {
    description   = "The name to use for all the cluster resources" 
    type          = string
    default       = "example-web"
}

variable "subnet_ids" {
    description = "The IDs for subnets that the EC2 instances in the ASG sit on"
    type        = list(string)
    default     = null  
}
