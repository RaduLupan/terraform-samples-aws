output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = module.hello-world-app.alb_dns_name
}

output "asg_name" {
    description = "The name of the Auto Scaling Group"
    value       = module.hello-world-app.asg_name
}

output "instance_security_group_id" {
    description = "The ID of the EC2 instance Security Group"
    value       = module.hello-world-app.instance_security_group_id
}
