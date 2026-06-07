variable "project_name" {
  type        = string
  description = "Project name used for tagging resources"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where resources will be created"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the EC2 instance will be launched"
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
  default     = "t3.micro"
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "The CIDR block allowed to SSH into the EC2 instance"

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "ssh_allowed_cidr debe ser un CIDR válido, por ejemplo 203.0.113.4/32."
  }
}
