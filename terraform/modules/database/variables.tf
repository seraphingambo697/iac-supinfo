variable "name" {
  description = "Préfixe des noms de ressources (projet-environnement)"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets privés où placer la base"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group de la base (MySQL depuis les EC2 uniquement)"
  type        = string
}

variable "instance_class" {
  description = "Taille de l'instance RDS"
  type        = string
}

variable "multi_az" {
  description = "Réplique de secours dans une seconde AZ (bascule automatique)"
  type        = bool
}

variable "backup_retention" {
  description = "Nombre de jours de sauvegardes automatiques (0 = désactivé)"
  type        = number
}

variable "db_name" {
  description = "Nom de la base de données PrestaShop"
  type        = string
  default     = "prestashop"
}

variable "db_username" {
  description = "Utilisateur de la base de données"
  type        = string
  default     = "prestashop"
}
