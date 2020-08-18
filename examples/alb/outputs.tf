output "alb_dns_name" {
    description = "The domain of the load balancer"
    value       = module.alb.alb_dns_name
}