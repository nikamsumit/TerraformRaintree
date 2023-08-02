variable "workspace" {
  description = "Terraform workspace name (dev or prod)"
  type        = string
}

variable "region" {
  description = "AWS region for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
}

variable "db_backup_retention_period" {
  description = "Backup retention period for the RDS instance"
  type        = number
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "auto_pause" {
  description = "Whether to enable auto pause for the RDS instance"
  type        = bool
}

variable "max_capacity" {
  description = "Max capacity for serverless RDS instances"
  type        = number
}

variable "min_capacity" {
  description = "Min capacity for serverless RDS instances"
  type        = number
}

variable "kms_key_id" {
  description = "ID of the KMS key for encryption"
  type        = string
}
