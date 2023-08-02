variable "workspace" {
  description = "Terraform workspace name (dev or prod)"
  type        = string
}

variable "region" {
  description = "AWS region for the S3 bucket"
  type        = string
}

variable "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  type        = string
}

variable "file_storage_bucket_name" {
  description = "Name of the file storage S3 bucket"
  type        = string
}
