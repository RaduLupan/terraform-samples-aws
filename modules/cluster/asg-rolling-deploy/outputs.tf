output "alb-dns-name" {
    value = aws_lb.web.dns_name
}

output "asg-name" {
    value = aws_autoscaling_group.web.name
}
