terraform {
    required_version = ">= 0.12"

    # Partial configuration.  
    # terraform init -backend-config ../../../backend.hcl will initialize the remote backend.
    backend "s3" {  
        key            = "stage/services/webserver-cluster/terraform.tfstate"
    }
}
provider "aws" {
    version = "2.70.0"
    region  = var.region
}

locals {
    project = "terraform-samples"

}

# Deploys a security group for the launch configuration with ingress rule to allow http traffic.
resource "aws_security_group" "allow_http" {
  name        = "allow-http-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ## Allow all outbound requests. Unlike creating an SG in the AWS console, egress rules are NOT automatically created!
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow-http"
    environment = var.environment
    terraform   = true
  }
}

# Deploys a security group for the Application Load Balancer with ingress rule to allow http traffic.
resource "aws_security_group" "sg_alb_web" {
  name        = "alb-web-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

## Allow all outbound requests. Unlike creating an SG in the AWS console, egress rules are NOT automatically created!
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow-http"
    environment = var.environment
    terraform   = true
  }
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

# Deploys launch configuration for the web auto scaling group.
resource "aws_launch_configuration" "asg_launch_config" {
  name_prefix     = "lc-web-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.allow_http.id] 

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=private
data "aws_subnet_ids" "private_subnet" {
  vpc_id = var.vpc_id

  tags = {
    tier = "private"
  }
}

resource "aws_autoscaling_group" "asg_web" {
    launch_configuration = aws_launch_configuration.asg_launch_config.name
    # The list of private subnet IDs provided by the data source is fed to the vpc_zone_identifier argument.
    vpc_zone_identifier  = data.aws_subnet_ids.private_subnet.ids

    target_group_arns = [aws_lb_target_group.tg_alb_web.arn]
    health_check_type = "ELB"
 
    min_size = 2
    max_size = 10

    tag {
        key                 = "Name"
        value               = "terraform-web-asg"      
        propagate_at_launch = true
    }
}

# Use this data source to provide the set of subnet IDs in our VPC that are tagged tier=public.
data "aws_subnet_ids" "public_subnet" {
  vpc_id = var.vpc_id

  tags = {
    tier = "public"
  }
}

# Deploys Application Load Balancer.
resource "aws_lb" "alb_web" {
    name               = "terraform-web-alb"
    load_balancer_type = "application"
    # The list of public subnet IDs provided by the data source is fed to the subnets argument.
    subnets            = data.aws_subnet_ids.public_subnet.ids
    security_groups    = [aws_security_group.sg_alb_web.id]
}

# Deploys http listener.
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.alb_web.arn
    port              = 80
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
resource "aws_lb_target_group" "tg_alb_web" {
    name     = "terraform-web-tg"
    port     = var.server_port
    protocol = "HTTP"
    vpc_id   = var.vpc_id

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
        target_group_arn = aws_lb_target_group.tg_alb_web.arn
    }
}