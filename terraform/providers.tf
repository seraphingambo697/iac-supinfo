terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    # Permet de déclarer les hôtes Ansible dans Terraform (inventaire dynamique)
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.region

  # Tags ajoutés automatiquement à toutes les ressources AWS
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = local.env
      ManagedBy   = "terraform"
    }
  }
}
