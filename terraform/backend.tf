# Le state est stocké dans S3 (bucket créé par bootstrap/)
# Un bloc backend ne peut pas utiliser de variables : les valeurs sont en dur.
terraform {
  backend "s3" {
    bucket       = "taylor-shift-tfstate-127372372064"
    key          = "taylor-shift/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true # verrou natif S3 : empêche deux apply simultanés
  }
}
