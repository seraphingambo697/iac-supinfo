output "public_ips" {
  description = "IP publiques des instances (connexion SSH d'Ansible)"
  value       = aws_instance.web[*].public_ip
}

output "instance_ids" {
  description = "IDs des instances EC2"
  value       = aws_instance.web[*].id
}
