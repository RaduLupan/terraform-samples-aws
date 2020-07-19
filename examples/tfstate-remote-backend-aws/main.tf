# This template deploys a backend for Terraform state in AWS consisting of:
# - 1 x S3 bucket with versioning and default server-side encryption enabled to store the terraform state
# - 1 s DynamoDB table to manage the locks

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
    region = var.region
}

# Random string appended at the end of the S3 bucket name to make it unique
resource "random_string" "random" {
    length  = 12
    special = false
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-${var.environment}-${var.region}-${lower(random_string.random.result)}"
    # Prevent accidental deletion of this S3 bucket
    lifecycle {
        prevent_destroy = true
    }

    # Enable versioning

    versioning {
        enabled = true
    }

    # Enable default server-side encryption
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name         ="terraform-locks-${var.environment}-${var.region}"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"    

    attribute {
        name = "LockID"
        type = "S"
    }
}

output "tfstate-bucket-name" {
    value = "aws_s3_bucket.terraform_state.name"
}

output "tflocks-table-name" {
    value = "aws_dynamodb_table.terraform_locks.name"
}