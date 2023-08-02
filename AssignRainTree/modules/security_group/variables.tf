variable "workspace" {
  description = "Terraform workspace name (dev or prod)"
  type        = string
}

variable "region" {
  description = "AWS region for the security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "backend_alb_sg_id" {
  description = "ID of the security group attached to the backend ALB"
  type        = string
}
