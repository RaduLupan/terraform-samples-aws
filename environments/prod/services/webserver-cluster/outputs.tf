# ALB DNS name output from webserver-cluster module
output "alb-dns-name" {
    description = "The domain name of the load balancer"
    value       = module.webserver-cluster.alb-dns-name
}
