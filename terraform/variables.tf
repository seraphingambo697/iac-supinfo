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
