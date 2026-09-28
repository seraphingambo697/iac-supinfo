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

module "database" {
  source            = "./modules/database"
  name              = local.name
  subnet_ids        = module.network.private_subnet_ids
  security_group_id = module.network.db_sg_id
  instance_class    = local.config.db_class
  multi_az          = local.config.db_multi_az
  backup_retention  = local.env == "prod" ? 7 : 0
}

module "storage" {
  source            = "./modules/storage"
  name              = local.name
  subnet_ids        = module.network.private_subnet_ids
  security_group_id = module.network.efs_sg_id
}
