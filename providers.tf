###############################################################################
# Ajustes de Terraform, proveedor AWS y backend de estado remoto
###############################################################################

terraform {
  # Versión mínima de Terraform requerida para este proyecto.
  required_version = ">= 1.5.0"

  # Proveedores necesarios y el rango de versiones permitido.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend remoto: el estado (.tfstate) se guarda cifrado en S3 y se bloquea
  # con DynamoDB para evitar que dos ejecuciones simultáneas lo corrompan.
  backend "s3" {
    bucket         = "ops-infra-bootstrap-tfstate-valentin-unique"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ops-infra-bootstrap-tfstate-locks"
    encrypt        = true
  }
}

# Proveedor AWS. Las default_tags se aplican automáticamente a TODOS los
# recursos, así no hay que repetir las etiquetas en cada uno.
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
