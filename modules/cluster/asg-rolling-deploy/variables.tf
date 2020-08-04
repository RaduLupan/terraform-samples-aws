variable "region" {
    description = "AWS Region"
    type        = string

}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "cluster_name" {
    description   = "The name to use for all the cluster resources" 
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

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
}

variable "min_size" {
    description = "The minimum number of EC2 instances in the ASG"
    type        = number
}

variable "max_size" {
    description = "The maximum number of EC2 instances in the ASG"
    type        = number
}

variable "custom_tags" {
    description = "Custom tags to set on the instances in the ASG"
    type        = map(string)
    default     = {}
}

variable "enable_autoscaling" {
    description = "If set to true, enable auto scaling"
}

variable "ami" {
    description = "The AMI to run in the cluster"
    type        = string 
    default     = "ami-0a63f96e85105c6d3"
}