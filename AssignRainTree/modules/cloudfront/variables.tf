variable "region" {
  description = "AWS region for the CloudFront distribution"
  type        = string
}

variable "workspace" {
  description = "Terraform workspace name (dev or prod)"
  type        = string
}

variable "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}
