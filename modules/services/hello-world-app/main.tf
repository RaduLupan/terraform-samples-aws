# Calculated local values.
locals {
  vpc_id       = (
    var.vpc_id == null 
      ? data.terraform_remote_state.vpc[0].outputs.vpc-id
      : var.vpc_id
  )
  
  mysql_config = (
    var.mysql_config == null
      ? data.terraform_remote_state.db[0].outputs
      : var.mysql_config
  )
  
  public_subnet_ids = (
    var.public_subnet_ids == null
      ? data.aws_subnet_ids.public_subnet[0].ids
      : var.public_subnet_ids
  )

  private_subnet_ids = (
    var.private_subnet_ids == null
      ? data.aws_subnet_ids.private_subnet[0].ids
      : var.private_subnet_ids
  )

  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

# Use this data set to replace embedded bash scripts such as user_data with scripts that sit on different source.
data "template_file" "user_data" {
    template = file("${path.module}/user-data.sh")

    vars = {
        server_port = var.server_port
        db_address  = local.mysql_config.address
        db_port     = local.mysql_config.port
        server_text = var.server_text
    }
}

# Deploys target group with health check.
resource "aws_lb_target_group" "web" {
    name     = "hello-world-${var.environment}-tg"
    port     = var.server_port
    protocol = "HTTP"
    vpc_id   = local.vpc_id

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
    listener_arn = module.alb.alb_http_listener_arn
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

# Calls the asg-rolling-deploy module
module "asg" {
  source = "../../cluster/asg-rolling-deploy"
   
    region                  = var.region
    environment             = var.environment
    cluster_name            = "hello-world-${var.environment}"
    ami                     = var.ami
    user_data               = data.template_file.user_data.rendered

    ### TO DO: Need to refactor ASG to eliminate dependency on VPC module.
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/dev/vpc/terraform.tfstate"

    instance_type           = var.instance_type
    min_size                = var.min_size
    max_size                = var.max_size
    enable_autoscaling      = var.enable_autoscaling
 
    subnet_ids              = local.private_subnet_ids
    target_group_arns       = [aws_lb_target_group.web.arn]
    custom_tags             = var.custom_tags
}

module "alb" {
    source = "../../networking/alb"
   
    region                  = var.region
    environment             = "dev"
    alb_name                = "hello-world-${var.environment}"
    subnet_ids              = local.public_subnet_ids
    
    ### TO DO: Need to refactor ALB to eliminate dependency on vpc module.
    vpc_remote_state_bucket = "terraform-state-dev-us-east-2-fkaymsvstthc"
    vpc_remote_state_key    = "environments/dev/vpc/terraform.tfstate"
}