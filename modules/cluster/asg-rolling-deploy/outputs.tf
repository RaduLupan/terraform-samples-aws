output "asg_name" {
    description = "The name of the Auto Scaling Group"
    value       = aws_autoscaling_group.web.name
}

output "instance_security_group_id" {
    description = "The ID of the EC2 instance Security Group"
    value       = aws_security_group.launch_config.id
}

