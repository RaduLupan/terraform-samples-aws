variable "region" {
    description = "AWS Region"
    type        = string
    
}

variable "vpcCidr" {
    description = "VPC CIDR Block"
    type        = string
    default = "10.0.0.0/16"
}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}