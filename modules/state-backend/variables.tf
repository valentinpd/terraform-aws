variable "project_name" {
  type        = string
  description = "Project name used for tagging resources"
}

variable "state_bucket_name" {
  type        = string
  description = "The globally unique name of the S3 bucket for Terraform state"
}
