variable "region" {
  description = "Région AWS de déploiement"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Préfixe utilisé pour nommer toutes les ressources"
  type        = string
  default     = "taylor-shift"
}

variable "vpc_cidr" {
  description = "Plage d'adresses IP du VPC"
  type        = string
  default     = "10.0.0.0/16"
}
