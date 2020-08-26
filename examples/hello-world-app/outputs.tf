output "alb_dns_name" {
    description = "The domain name of the load balancer"
    value       = module.hello_world_app.alb_dns_name
}