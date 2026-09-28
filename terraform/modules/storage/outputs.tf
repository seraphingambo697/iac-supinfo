output "efs_id" {
  description = "ID du système de fichiers EFS"
  value       = aws_efs_file_system.main.id
}

output "efs_dns_name" {
  description = "Nom DNS utilisé pour monter EFS"
  value       = aws_efs_file_system.main.dns_name
}
