variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "The name of the project to tag resources with"
}

variable "state_bucket_name" {
  type        = string
  description = "The globally unique name of the S3 bucket to store Terraform state"
}

variable "state_table_name" {
  type        = string
  description = "The name of the DynamoDB table for state locking"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
  default     = "t2.micro"
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "The CIDR block allowed to SSH into the EC2 instance"
  default     = "0.0.0.0/0"
}
