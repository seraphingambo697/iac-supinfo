output "environment" {
  description = "Environnement actuellement déployé (dépend du workspace)"
  value       = local.env
}

output "vpc_id" {
  description = "ID du VPC créé"
  value       = module.network.vpc_id
}

output "db_endpoint" {
  description = "Adresse de la base RDS"
  value       = module.database.endpoint
}

output "efs_id" {
  description = "ID du système de fichiers EFS"
  value       = module.storage.efs_id
}

output "app_url" {
  description = "URL publique de la boutique PrestaShop"
  value       = "http://${module.alb.dns_name}"
}

output "web_public_ips" {
  description = "IP publiques des EC2"
  value       = module.compute.public_ips
}
