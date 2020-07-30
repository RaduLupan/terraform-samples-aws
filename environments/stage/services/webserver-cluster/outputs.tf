# ALB DNS name output from webserver-cluster module
output "alb-dns-name" {
    value = module.webserver-cluster.alb-dns-name
}
