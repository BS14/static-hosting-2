output "target_group_arn" {
  description = "The ARN of the Target Group to be used by the ASG"
  value       = aws_lb_target_group.tg.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer for your Cloudflare CNAME record"
  value       = aws_lb.main.dns_name
}
