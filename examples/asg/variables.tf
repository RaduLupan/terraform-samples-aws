variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"
}

variable "cluster_name" {
    description   = "The name to use for all the cluster resources" 
    type          = string
}
