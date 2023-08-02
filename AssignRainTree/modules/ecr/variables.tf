variable "workspace" {
  description = "Terraform workspace name (dev or prod)"
  type        = string
}

variable "region" {
  description = "AWS region for the ECR repository"
  type        = string
}

variable "backend_ecr_repo_name" {
  description = "Name of the backend ECR repository"
  type        = string
}
