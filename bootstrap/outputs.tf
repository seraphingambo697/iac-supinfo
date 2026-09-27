output "state_bucket_name" {
  description = "Nom du bucket S3 à utiliser dans le backend du projet principal"
  value       = aws_s3_bucket.tfstate.bucket
}
