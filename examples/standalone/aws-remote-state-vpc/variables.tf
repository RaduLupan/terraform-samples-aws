#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "vpc_remote_state_bucket" {
    description = "The name of the S3 bucket for the VPC's remote state"
    type        = string
    default     = "terraform-state-dev-us-east-2-fkaymsvstthc"
}

variable "vpc_remote_state_key" {
    description = "The path for the VPC's remote state in S3"
    type        = string
    default     = "environments/test/vpc/terraform.tfstate"
}

variable "subnet_ids" {
    description = "The subnet IDs to deploy to"
    type        = list(string) 
    default     = null
}

variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"    
}