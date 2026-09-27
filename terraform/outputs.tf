output "environment" {
  description = "Environnement actuellement déployé (dépend du workspace)"
  value       = local.env
}

output "vpc_id" {
  description = "ID du VPC créé"
  value       = module.network.vpc_id
}
