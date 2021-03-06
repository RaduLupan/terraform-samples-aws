# This template deploys the following AWS resources:
# - 1 x Auto Scaling Group of EC2 instances running Ubuntu.
# The ASG is configured to do zero downtime deployments.

# Use this data source to get info about a subnet, in this case extract the vpc_id.
data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

# Calculated local values.
locals {
  vpc_id       = data.aws_subnet.selected.vpc_id
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

# Deploys a security group for the launch configuration, no inline rules.
resource "aws_security_group" "launch_config" {
  name        = "${var.cluster_name}-ec2-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = local.vpc_id

  tags = {
    Name        = "allow-http"
    environment = var.environment
    terraform   = true
  }
}

# Security group rules are defined as separate resources for more flexibility.
resource "aws_security_group_rule" "allow_http_inbound_ec2" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_config.id
 
  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}
  
# Allows all outbound requests. Unlike creating an SG in the AWS console, egress rules are NOT automatically created!
resource "aws_security_group_rule" "allow_all_outbound_ec2" { 
  type              = "egress"
  security_group_id = aws_security_group.launch_config.id
  
  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

# Deploys launch configuration for the web auto scaling group.
resource "aws_launch_configuration" "asg_launch_config" {
  name_prefix     = "lc-"
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.launch_config.id] 
  user_data       = var.user_data

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
    # Explicitly depend on the launch configuration's name so each time it's replaced this ASG is also replaced.
    name                 = "${var.cluster_name}-${aws_launch_configuration.asg_launch_config.name}"
    launch_configuration = aws_launch_configuration.asg_launch_config.name
    
    vpc_zone_identifier  = var.subnet_ids

    # Configure integrations with a load balancer
    target_group_arns = var.target_group_arns
    health_check_type = var.health_check_type
 
    min_size = var.min_size
    max_size = var.max_size

    # Wait for at least this many instances to pass health checks before considering the ASG deployment complete.
    min_elb_capacity = var.min_size

    # When replacing this ASG, create the replacement first, and only delete the original after.
    lifecycle {
      create_before_destroy = true
    }

    tag {
        key                 = "Name"
        value               = "${var.cluster_name}-instance"      
        propagate_at_launch = true
    }

    # Dynamically generates inline tag blocks with for_each.
    dynamic "tag" {
      for_each = var.custom_tags

      content {
        key                 = tag.key
        value               = tag.value
        propagate_at_launch = true
      }
    }
}

# Deploys scale out autoscaling_schedule on condition that var.enable_autoscaling is true.
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 3
  max_size               = 10
  desired_capacity       = 3
  recurrence             ="0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.web.name
}

# Deploys scale in autoscaling_schedule on condition that var.enable_autoscaling is true.
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
  min_size               = 1
  max_size               = 10
  desired_capacity       = 1
  recurrence             ="0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.web.name
}

# Deploys CloudWatch alarm on condition that instance_type starts with "t" as the CPUCreditBalance only applies to "t" class.
resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}