variable "name" {
  description = "Préfixe des noms de ressources (projet-environnement)"
  type        = string
}

variable "vpc_id" {
  description = "VPC du target group"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets publics où placer le load balancer (2 AZ minimum)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group du load balancer"
  type        = string
}
