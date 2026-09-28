terraform {
  required_version = ">= 1.10"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Numéro de compte, pour un nom de bucket unique au monde
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "tfstate" {
  bucket = "taylor-shift-tfstate-${data.aws_caller_identity.current.account_id}"

  lifecycle {
    prevent_destroy = true # protège le state contre un destroy accidentel
  }
}

# Versioning : on peut récupérer une ancienne version du state si besoin
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Chiffrement du state (il contient des infos sensibles)
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Aucun accès public possible
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Génère terraform/backend.tf avec le bucket de CE compte AWS :
# le projet principal est ainsi utilisable sur n'importe quel compte.
resource "local_file" "backend" {
  filename        = "${path.module}/../terraform/backend.tf"
  file_permission = "0644"
  content         = <<-EOT
    # Fichier généré par bootstrap/ : ne pas modifier à la main
    terraform {
      backend "s3" {
        bucket       = "${aws_s3_bucket.tfstate.bucket}"
        key          = "taylor-shift/terraform.tfstate"
        region       = "${var.region}"
        encrypt      = true
        use_lockfile = true
      }
    }
  EOT
}
