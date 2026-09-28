# Mot de passe généré aléatoirement : jamais écrit dans le code
resource "random_password" "db" {
  length  = 24
  special = false # évite les caractères refusés par RDS
}

# Stocké chiffré dans SSM Parameter Store, lu ensuite par Ansible
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.name}/db_password"
  description = "Mot de passe RDS PrestaShop"
  type        = "SecureString"
  value       = random_password.db.result
}

# Groupe de subnets : RDS peut être placé dans n'importe quel subnet privé
resource "aws_db_subnet_group" "main" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "main" {
  identifier     = "${var.name}-db"
  engine         = "mariadb"
  engine_version = "10.11"
  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible    = false
  multi_az               = var.multi_az

  backup_retention_period = var.backup_retention
  skip_final_snapshot     = true # projet école : pas de snapshot au destroy
  deletion_protection     = false
  apply_immediately       = true
}
