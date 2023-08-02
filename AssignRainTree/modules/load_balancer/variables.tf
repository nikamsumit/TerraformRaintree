variable "workspace" {
  description = "Terraform workspace name (dev or prod)"
  type        = string
}

variable "region" {
  description = "AWS region for the load balancer"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "backend_target_group_arn" {
  description = "ARN of the backend target group"
  type        = string
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
}
