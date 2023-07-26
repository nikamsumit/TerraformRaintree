variable "backend_desired_count" {
  description = "count of backend ECS tasks"
  type        = number
  default     = 1
}

variable "backend_cpu" {
  description = "The CPU units for the backend ECS task"
  type        = string
  default     = "256"
}

variable "backend_memory" {
  description = "The memory for the backend ECS task"
  type        = string
  default     = "512"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the ALB and ECS tasks will be deployed"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID of the VPC where the ALB and ECS tasks will be deployed"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
}
