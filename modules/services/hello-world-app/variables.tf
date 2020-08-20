#----------------------------------------------------------------------------
# REQUIRED PARAMETERS: You must provide a value for each of these parameters.
#----------------------------------------------------------------------------

variable "region" {
    description = "AWS Region"
    type        = string 
}

variable "environment" {
    description   = "Environment i.e. dev, test, stage, prod" 
    type          = string
}

variable "min_size" {
    description = "The minimum number of EC2 instances in the ASG"
    type        = number
}

variable "max_size" {
    description = "The maximum number of EC2 instances in the ASG"
    type        = number
}

variable "enable_autoscaling" {
    description = "If set to true, enable auto scaling"
}

#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "cluster_name" {
    description   = "The name to use for all the cluster resources" 
    type          = string
    default       = "web-cluster"  
}

variable "vpc_remote_state_bucket" {
    description = "The name of the S3 bucket for the VPC's remote state"
    type        = string
    default     = null
}

variable "vpc_remote_state_key" {
    description = "The path for the VPC's remote state in S3"
    type        = string
    default     = null
}

variable "vpc_id" {
    description = "The ID of the VPC to deploy into"
    type        = string
    default     = null
}

variable "public_subnet_ids" {
    description = "The IDs of the public subnets to deploy the ALB into"
    type        = string
    default     = null
}

variable "private_subnet_ids" {
    description = "The IDs of the private subnets to deploy the EC2 instances into"
    type        = string
    default     = null
}

variable "db_remote_state_bucket" {
    description = "The name of the S3 bucket for the MySQL DB remote state"
    type        = string
    default     = null
}

variable "db_remote_state_key" {
    description = "The path for the DB's remote state in S3"
    type        = string
    default     = null
}

variable "mysql_config" {
    description = "The config for the MySQL DB"
    # This object type matches the output types of the mysql module.
    type        = object({
        address = string
        port    = number
    })
    default     null
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
}

variable "custom_tags" {
    description = "Custom tags to set on the instances in the ASG"
    type        = map(string)
    default     = {}
}

variable "ami" {
    description = "The AMI to run in the cluster"
    type        = string 
    default     = "ami-0a63f96e85105c6d3"
}

variable "server_text" {
    description = "The text the web server should return"
    type        = string 
    default     = "Hello, World"
}

variable "server_port" {
    description = "Internal server port for HTTP"
    type        = number
    default     = 8080
}