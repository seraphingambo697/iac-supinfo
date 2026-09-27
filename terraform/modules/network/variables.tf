variable "name" {
  description = "Préfixe des noms de ressources (projet-environnement)"
  type        = string
}

variable "vpc_cidr" {
  description = "Plage d'adresses IP du VPC"
  type        = string
}

variable "az_count" {
  description = "Nombre de zones de disponibilité utilisées (haute disponibilité)"
  type        = number
  default     = 2
}

variable "admin_cidr" {
  description = "IP autorisée en SSH vers les EC2 (format x.x.x.x/32)"
  type        = string
}
