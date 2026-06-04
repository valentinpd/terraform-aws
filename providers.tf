terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Activamos el backend remoto apuntando al nuevo bucket privado
  backend "s3" {
    bucket         = "ops-infra-bootstrap-tfstate-valentin-unique"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ops-infra-bootstrap-tfstate-locks"
    encrypt        = true
  }
}

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
