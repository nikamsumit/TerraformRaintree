variable "workspace" {
  description = "Terraform workspace name (dev or prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "backend_ecr_repo_url" {
  description = "URL of the backend ECR repository"
  type        = string
}

variable "backend_task_execution_role_arn" {
  description = "ARN of the ECS task execution role for the backend service"
  type        = string
}
