terraform {
    required_version = ">= 0.12, < 0.13"
}

provider "aws" {
    version = "2.70.0"
    region  = var.region
}

# Deploys IAM policy that allows read-only access to CloudWatch.
resource "aws_iam_policy" "cloudwatch_read_only" {
    name   = "cloudwatch-read-only"
    policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
    statement {
        effect  = "Allow"
        actions = [
            "CloudWatch:Describe*",
            "CloudWatch:Get*",
            "CloudWatch:List*"
        ]
        resources = ["*"]
    }
}

# Deploys IAM policy that allows full access to CloudWatch.
resource "aws_iam_policy" "cloudwatch_full_access" {
    name   = "cloudwatch-full-access"
    policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
    statement {
        effect  = "Allow"
        actions = ["CloudWatch:*"]
        resources = ["*"]
    }
}


