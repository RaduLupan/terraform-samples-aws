# This template deploys the following AWS resources:
# - 1 x Auto Scaling Group of EC2 instances running Ubuntu (web servers)
# - 1 x Target Group for HTTP protocol associated with the ASG
# - 1 x Application Load Balancer with HTTP listener forwarding traffic to the Target Group

# Use this data source to get the VPC Id output from the remote state file of the vpc module.
data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
        bucket = var.vpc_remote_state_bucket
        key    = var.vpc_remote_state_key
        region = var.region
    }
}

# Use this data source to get the db-endpoint and port outputs from the remote state file of the mysql module.
data "terraform_remote_state" "db" {
    backend = "s3"

    config = {
        bucket = var.db_remote_state_bucket
        key    = var.db_remote_state_key
        region = var.region
    }
}

# Calculated local values.
locals {
  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc-id
  db_address   = data.terraform_remote_state.db.outputs.db-endpoint
  db_port      = data.terraform_remote_state.db.outputs.port
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

# Deploys a security group for the Application Load Balancer, no inline rules.
resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = local.vpc_id

  tags = {
    Name        = "allow-http"
    environment = var.environment
    terraform   = true
  }
}
 
# Security group rules are defined as separate resources for more flexibility.
resource "aws_security_group_rule" "allow_http_inbound_alb" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
 
  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

# Allow all outbound requests. Unlike creating an SG in the AWS console, egress rules are NOT automatically created!
resource "aws_security_group_rule" "allow_all_outbound_alb" { 
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  
  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

# Use this data source to get the ID of a registered AMI for use in other resources.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Use this data set to replace embedded bash scripts such as user_data with scripts that sit on different source.
data "template_file" "user_data" {
    template = file("${path.module}/user-data.sh")

    vars = {
        server_port = var.server_port
        db_address  = local.db_address
        db_port     = local.db_port
    }
}

# Deploys launch configuration for the web auto scaling group.
resource "aws_launch_configuration" "asg_launch_config" {
  name_prefix     = "lc-${var.cluster_name}-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.launch_config.id] 
  user_data       = data.template_file.user_data.rendered

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=private
data "aws_subnet_ids" "private_subnet" {
  vpc_id = local.vpc_id

  tags = {
    tier = "private"
  }
}

resource "aws_autoscaling_group" "web" {
    launch_configuration = aws_launch_configuration.asg_launch_config.name
    # The list of private subnet IDs provided by the data source is fed to the vpc_zone_identifier argument.
    vpc_zone_identifier  = data.aws_subnet_ids.private_subnet.ids

    target_group_arns = [aws_lb_target_group.web.arn]
    health_check_type = "ELB"
 
    min_size = var.min_size
    max_size = var.max_size

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

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=public.
data "aws_subnet_ids" "public_subnet" {
  vpc_id = local.vpc_id

  tags = {
    tier = "public"
  }
}

# Deploys Application Load Balancer.
resource "aws_lb" "web" {
    name               = "${var.cluster_name}-alb"
    load_balancer_type = "application"
    # The list of public subnet IDs provided by the data source is fed to the subnets argument.
    subnets            = data.aws_subnet_ids.public_subnet.ids
    security_groups    = [aws_security_group.alb.id]
}

# Deploys http listener.
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.web.arn
    port              = local.http_port
    protocol          = "HTTP"

    # By default, return a simple 404 page
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code  = 404
        }
    }
}

# Deploys target group with health check.
resource "aws_lb_target_group" "web" {
    name     = "${var.cluster_name}-tg"
    port     = var.server_port
    protocol = "HTTP"
    vpc_id   = data.terraform_remote_state.vpc.outputs.vpc-id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

# Deploys listener rule that sends requests for any path to the target group that contains the auto scaling group.
resource "aws_lb_listener_rule" "rule" {
    listener_arn = aws_lb_listener.http.arn
    priority     = 100

    condition {
      path_pattern {
        values = ["/*"]
      }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web.arn
    }
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