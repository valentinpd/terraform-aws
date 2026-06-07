###############################################################################
# Módulo: state-backend
# Crea la infraestructura donde Terraform guarda su estado de forma segura:
#   - Bucket S3 (cifrado, versionado y sin acceso público) para el .tfstate
#
# El bloqueo (lock) lo gestiona el propio S3 mediante un fichero .tflock
# (use_lockfile en providers.tf), así que aquí ya no hace falta DynamoDB.
###############################################################################

# Bucket S3 que almacenará el fichero de estado.
resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.state_bucket_name
  force_destroy = false

  # prevent_destroy evita borrar el bucket por accidente (perderías el estado).
  lifecycle {
    prevent_destroy = true
  }
}

# Versionado: guarda el historial de cambios del estado (permite recuperar).
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado en reposo por defecto (AES-256).
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloquea cualquier acceso público al bucket (el estado es sensible).
resource "aws_s3_bucket_public_access_block" "state_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
