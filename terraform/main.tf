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

module "alb" {
  source            = "./modules/alb"
  name              = local.name
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.network.alb_sg_id
}

module "compute" {
  source              = "./modules/compute"
  name                = local.name
  instance_count      = local.config.instance_count
  instance_type       = local.config.instance_type
  subnet_ids          = module.network.public_subnet_ids
  security_group_id   = module.network.web_sg_id
  target_group_arn    = module.alb.target_group_arn
  ssh_public_key_path = var.ssh_public_key_path
}

# --- Inventaire Ansible, lu par le plugin cloud.terraform.terraform_provider ---

# Variables communes à tous les serveurs web (aucun secret ici)
resource "ansible_group" "web" {
  name = "web"
  variables = {
    aws_region      = var.region
    db_host         = module.database.endpoint
    db_name         = module.database.db_name
    db_user         = module.database.db_username
    db_password_ssm = module.database.password_ssm_name
    efs_dns_name    = module.storage.efs_dns_name
    ps_domain       = module.alb.dns_name
  }
}

resource "ansible_host" "web" {
  count  = local.config.instance_count
  name   = "web-${count.index}"
  groups = [ansible_group.web.name]
  variables = {
    ansible_host = module.compute.public_ips[count.index]
    ansible_user = "ubuntu"
  }
}
