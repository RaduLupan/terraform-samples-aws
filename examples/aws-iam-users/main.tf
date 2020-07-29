terraform {
    required_version = ">= 0.12, < 0.13"
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

# for_each loop removes count limitations: 1. not looping through inline blocks and 2. removing resources based on index.
resource "aws_iam_user" "example" {
    # Convert list to set to allow it to work with for_each
    for_each = toset(var.user_names)
    name     = each.value
}

# all_users is a map where keys are user names and values are user attributes.
output "all_users" {
    value = aws_iam_user.example
}

# Use values built-in function (which returns just the values from a map) and a splat expression.
output "all_arns" {
    value = values(aws_iam_user.example)[*].arn
}