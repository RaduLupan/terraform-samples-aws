output "alb_dns_name" {
    description = "The domain of the load balancer"
    value       = module.alb.alb_dns_name
}

output "alb_http_listener_arn" {
    description = "The ARN of the HTTP listener"
    value       = module.alb.alb_http_listener_arn
}

output "alb_security_group_id" {
    description = "The ALB Security Group ID"
    value       = module.alb.alb_security_group_id
}