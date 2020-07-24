variable "region" {
    description = "AWS Region"
    type        = string

}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "vpc_id" {
    description = "The VPC ID for the VPC where the auto scaling group will be deployed"
    type        = string
}
variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
}

variable "server_port" {
    description = "Internal server port for HTTP"
    type        = number
}