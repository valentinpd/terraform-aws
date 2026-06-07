variable "project_name" {
  type        = string
  description = "Project name used for tagging resources"
}

variable "state_bucket_name" {
  type        = string
  description = "The globally unique name of the S3 bucket for Terraform state"
}

variable "state_table_name" {
  type        = string
  description = "The name of the DynamoDB table for state locking"
}
