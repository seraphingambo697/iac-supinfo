output "endpoint" {
  description = "Adresse DNS de la base (sans le port)"
  value       = aws_db_instance.main.address
}

output "db_name" {
  description = "Nom de la base de données"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Utilisateur de la base de données"
  value       = aws_db_instance.main.username
}

output "password_ssm_name" {
  description = "Nom du paramètre SSM contenant le mot de passe"
  value       = aws_ssm_parameter.db_password.name
}
