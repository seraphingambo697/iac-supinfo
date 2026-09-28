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

variable "ssh_public_key_path" {
  description = "Chemin de la clé publique SSH déposée sur les EC2"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
