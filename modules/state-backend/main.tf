###############################################################################
# Módulo: state-backend
# Crea la infraestructura donde Terraform guarda su estado de forma segura:
#   - Bucket S3 (cifrado, versionado y sin acceso público) para el .tfstate
#   - Tabla DynamoDB para el bloqueo (lock) que evita ejecuciones simultáneas
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

# Tabla DynamoDB para el lock del estado. Terraform escribe aquí un registro
# mientras opera y lo borra al terminar; así dos personas no corren a la vez.
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.state_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
