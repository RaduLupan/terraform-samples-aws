variable "region" {
    description = "AWS Region"
    type        = string
}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "alb_name" {
    description   = "The name to use for this ALB" 
    type          = string
}

variable "vpc_remote_state_bucket" {
    description = "The name of the S3 bucket for the VPC's remote state"
    type        = string
}

variable "vpc_remote_state_key" {
    description = "The path for the VPC's remote state in S3"
    type        = string
}

variable "subnet_ids" {
    description = "The IDs for subnets that the ALB sits on"
    type        = list(string)
}

