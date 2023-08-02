variable "backend_desired_count" {
  description = "The desired number of tasks for the backend service."
}

variable "backend_cpu" {
  description = "The number of CPU units to reserve for the backend service."
}

variable "backend_memory" {
  description = "The amount of memory to allocate for the backend service (in MiB)."
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be created."
}

variable "backend_cluster_id" {
  type = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs in the selected VPC."
}

variable "db_username" {
  description = "Username for the RDS database."
}

variable "db_password" {
  description = "Password for the RDS database."
}
