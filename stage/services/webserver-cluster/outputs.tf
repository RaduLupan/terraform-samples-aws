output "alb-dns-name" {
    value = aws_lb.alb_web.dns_name
}

output "asg-name" {
    value = aws_autoscaling_group.asg_web.name
}
