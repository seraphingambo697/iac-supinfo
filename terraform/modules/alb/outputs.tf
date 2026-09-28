output "dns_name" {
  description = "Adresse publique du load balancer"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "Target group dans lequel enregistrer les EC2"
  value       = aws_lb_target_group.web.arn
}
