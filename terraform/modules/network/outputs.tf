output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Subnets publics (ALB, EC2)"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Subnets privés (RDS, EFS)"
  value       = aws_subnet.private[*].id
}

output "alb_sg_id" {
  description = "Security Group de l'ALB"
  value       = aws_security_group.alb.id
}

output "web_sg_id" {
  description = "Security Group des EC2"
  value       = aws_security_group.web.id
}

output "db_sg_id" {
  description = "Security Group de RDS"
  value       = aws_security_group.db.id
}

output "efs_sg_id" {
  description = "Security Group d'EFS"
  value       = aws_security_group.efs.id
}
