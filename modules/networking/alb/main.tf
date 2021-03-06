# This template deploys the following AWS resources:
# - 1 x Internet-facing Application Load Balancer into existing VPC

# Calculated local values.
locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

# Use this resource to extract the vpc_id from the first elelment of subnet_ids array.
data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

# Deploys a security group for the Application Load Balancer, no inline rules.
resource "aws_security_group" "alb" {
  name        = "${var.alb_name}-alb-sg"
  description = "Allow HTTP inbound traffic"
  # Place the security group in the same VPC with the subnets the ALB sits on.
  vpc_id      = data.aws_subnet.selected.vpc_id

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

# Deploys Application Load Balancer.
resource "aws_lb" "web" {
    name               = "${var.alb_name}-alb"
    load_balancer_type = "application"
    # The list of public subnet IDs provided by the data source is fed to the subnets argument.
    subnets            = var.subnet_ids
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

