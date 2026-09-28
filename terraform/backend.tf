# Fichier généré par bootstrap/ : ne pas modifier à la main
terraform {
  backend "s3" {
    bucket       = "taylor-shift-tfstate-127372372064"
    key          = "taylor-shift/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}
