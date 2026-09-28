variable "name" {
  description = "Préfixe des noms de ressources (projet-environnement)"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets où créer un point de montage EFS (un par AZ)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group d'EFS (NFS depuis les EC2 uniquement)"
  type        = string
}
