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

# Convert all user names to uppercase using for loop.
output "upper_names" {
    value = [for name in var.user_names: upper(name)]
}

# Filter the result by specifying a condition.
output "short_upper_names" {
    value = [for name in var.user_names: upper(name) if length(name) < 5]
}

# How to loop over a map with Terraform's for expression
variable "hero_thousand_faces" {
    description = "map"
    type        = map(string)
    default     = {
        neo      = "hero"
        trinity  = "love interest"
        morpheus = "mentor"
    }
}

# Output will be 'morpheus is the mentor', 'neo is the hero', 'trinity is the love interest'.
output "bios" {
    value = [for name, role in var.hero_thousand_faces: "${name} is the ${role}"]
}

# Transform a map to make all the keys and values uppercase.
output "upper_roles" {
    value = {for name, role in var.hero_thousand_faces: upper(name) => upper(role)}
}