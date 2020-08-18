variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "alb_name" {
    description   = "The name to use for this ALB" 
    type          = string
}

variable "subnet_ids" {
    description = "The IDs for subnets that the ALB sits on"
    type        = list(string)
}

