# IP publique de la machine qui lance Terraform (pour autoriser le SSH d'Ansible)
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

module "network" {
  source     = "./modules/network"
  name       = local.name
  vpc_cidr   = var.vpc_cidr
  az_count   = 2
  admin_cidr = "${chomp(data.http.my_ip.response_body)}/32"
}
