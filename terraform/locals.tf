locals {
  # Le workspace "default" (celui utilisé par les commandes de test) correspond à dev
  env = terraform.workspace == "default" ? "dev" : terraform.workspace

  # Taille de l'infrastructure selon l'environnement
  env_config = {
    dev = {
      instance_count = 2
      instance_type  = "t3.micro"
      db_class       = "db.t3.micro"
      db_multi_az    = false
    }
    staging = {
      instance_count = 2
      instance_type  = "t3.micro"
      db_class       = "db.t3.micro"
      db_multi_az    = false
    }
    prod = {
      instance_count = 3
      instance_type  = "t3.small"
      db_class       = "db.t3.small"
      db_multi_az    = true
    }
  }

  config = local.env_config[local.env]
  name   = "${var.project_name}-${local.env}"
}
