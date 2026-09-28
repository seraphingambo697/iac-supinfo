variable "name" {
  description = "Préfixe des noms de ressources (projet-environnement)"
  type        = string
}

variable "instance_count" {
  description = "Nombre d'instances EC2 PrestaShop"
  type        = number
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets publics (les instances sont réparties entre eux)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group des instances"
  type        = string
}

variable "target_group_arn" {
  description = "Target group de l'ALB où enregistrer les instances"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Clé publique SSH déposée sur les instances (utilisée par Ansible)"
  type        = string
}
