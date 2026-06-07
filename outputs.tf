###############################################################################
# Outputs del root module
#
# Valores útiles que Terraform muestra al terminar (y que se pueden consultar
# con `terraform output`). Cada uno se obtiene de la salida de su módulo.
###############################################################################

output "state_bucket_arn" {
  value       = module.state_backend.bucket_arn
  description = "ARN del bucket S3 que almacena el estado de Terraform."
}

output "state_dynamodb_table_name" {
  value       = module.state_backend.dynamodb_table_name
  description = "Nombre de la tabla DynamoDB usada para el bloqueo del estado."
}

output "vpc_id" {
  value       = module.networking.vpc_id
  description = "ID de la VPC creada."
}

output "public_subnet_id" {
  value       = module.networking.public_subnet_id
  description = "ID de la subred pública."
}

output "ec2_public_ip" {
  value       = module.compute.ec2_public_ip
  description = "IP pública de la instancia EC2."
}
