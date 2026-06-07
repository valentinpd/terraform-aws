###############################################################################
# Ajustes de Terraform, proveedor AWS y backend de estado remoto
###############################################################################

terraform {
  # Versión mínima requerida. Subimos a 1.10 porque usamos `use_lockfile`
  # (bloqueo de estado nativo en S3), disponible desde Terraform 1.10.
  required_version = ">= 1.10"

  # Proveedores necesarios y el rango de versiones permitido.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend remoto: el estado (.tfstate) se guarda cifrado en S3. El bloqueo
  # (lock) lo hace el propio S3 con un fichero .tflock (use_lockfile), sin
  # necesidad de DynamoDB, gracias a las escrituras condicionales de S3.
  backend "s3" {
    bucket       = "ops-infra-bootstrap-tfstate-valentin-unique"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
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
