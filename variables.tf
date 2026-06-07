###############################################################################
# Variables de entrada del proyecto (root module)
#
# Aquí solo se DECLARAN las variables: nombre, tipo, descripción y, cuando
# tiene sentido, un valor por defecto y/o una validación.
# Los VALORES reales se asignan en terraform.tfvars (que está en .gitignore
# porque puede contener datos sensibles como tu IP pública).
###############################################################################

# --- Configuración general ---

variable "aws_region" {
  type        = string
  description = "Región de AWS donde se despliegan los recursos (ej. us-east-1)."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Entorno de despliegue. Se usa para etiquetar los recursos."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment debe ser uno de: dev, staging o prod."
  }
}

variable "project_name" {
  type        = string
  description = "Nombre del proyecto. Se usa como prefijo en nombres y etiquetas."
}

# --- Backend de estado remoto (módulo state-backend) ---

variable "state_bucket_name" {
  type        = string
  description = "Nombre globalmente único del bucket S3 que guarda el estado de Terraform."
}

# --- Red (módulo networking) ---

variable "vpc_cidr" {
  type        = string
  description = "Bloque CIDR de la VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Bloque CIDR de la subred pública."
  default     = "10.0.1.0/24"
}

# --- Cómputo (módulo compute) ---

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2 a lanzar."
  default     = "t3.micro"
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "CIDR autorizado para conectar por SSH (puerto 22). Usa SIEMPRE tu IP con /32, nunca 0.0.0.0/0."

  # Sin valor por defecto a propósito: obliga a definirlo en terraform.tfvars
  # para no dejar nunca el SSH abierto a todo Internet por descuido.
  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "ssh_allowed_cidr debe ser un CIDR válido, por ejemplo 203.0.113.4/32."
  }
}
