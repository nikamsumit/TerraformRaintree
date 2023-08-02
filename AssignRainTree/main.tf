terraform {
  required_version = ">= 1.3.0, < 1.4.0"
}

# Define the current Terraform workspace (dev or prod)
locals {
  workspace = terraform.workspace
}

# Backend ECS module
module "ecs" {
  source = "./modules/ecs"

  workspace                     = local.workspace
  vpc_id                        = aws_vpc.main.id
  private_subnet_ids            = local.private_subnet_ids
  backend_ecr_repo_url          = module.ecr.backend_ecr_repo_url
  backend_task_execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

# Load balancer module
module "load_balancer" {
  source = "./modules/load_balancer"

  workspace             = local.workspace
  region                = "us-east-1"
  private_subnet_ids    = local.private_subnet_ids
  backend_target_group_arn = module.ecs.backend_target_group_arn
  ssl_certificate_arn   = "YOUR_SSL_CERTIFICATE_ARN"
}

# Security group module
module "security_group" {
  source = "./modules/security_group"

  workspace       = local.workspace
  region          = "us-east-1"
  vpc_id          = aws_vpc.main.id
  backend_alb_sg_id = module.load_balancer.backend_alb_sg_id
}

# S3 module
module "s3" {
  source = "./modules/s3"

  workspace               = local.workspace
  region                  = "us-east-1"
  frontend_bucket_name    = local.workspace == "dev" ? "dev-frontend-bucket" : "prod-frontend-bucket"
  file_storage_bucket_name = local.workspace == "dev" ? "dev-file-storage-bucket" : "prod-file-storage-bucket"
}

# ECR module
module "ecr" {
  source = "./modules/ecr"

  workspace               = local.workspace
  region                  = "us-east-1"
  backend_ecr_repo_name   = local.workspace == "dev" ? "dev-backend-repo" : "prod-backend-repo"
}

# RDS module for dev environment
module "rds_dev" {
  source = "./modules/rds"

  workspace                 = local.workspace
  region                    = "us-east-1"
  db_username               = "db_user" 
  db_password               = "db_password"  
  db_backup_retention_period = 7
  private_subnet_ids        = local.private_subnet_ids
  db_instance_class         = "db.t2.small"
  auto_pause                = true
  max_capacity              = 8
  min_capacity              = 2
  kms_key_id                = data.aws_kms_alias.kms_xac_alias.target_key_arn
}

# RDS module for prod environment
module "rds_prod" {
  source = "./modules/rds"

  workspace                 = local.workspace
  region                    = "us-west-2"
  db_username               = "db_user"  
  db_password               = "db_password"  
  db_backup_retention_period = 35
  private_subnet_ids        = local.private_subnet_ids
  db_instance_class         = "db.r5.large"
  auto_pause                = false
  max_capacity              = 8
  min_capacity              = 2
  kms_key_id                = data.aws_kms_alias.kms_xac_alias.target_key_arn
}

# Cloudfront module
module "cloudfront" {
  source = "./modules/cloudfront"

  region                = "us-east-1"
  workspace             = local.workspace
  frontend_bucket_name  = module.s3.frontend_bucket_name
  acm_certificate_arn   = "YOUR_ACM_CERTIFICATE_ARN"
}

# Route 53 module
module "route53" {
  source = "./modules/route53"

  region                  = "us-east-1"
  workspace               = local.workspace
  cloudfront_domain_name  = local.workspace == "dev" ? "dev.mydomain.com" : "prod.mydomain.com"
}

# Data source to fetch the KMS alias
data "aws_kms_alias" "kms_xac_alias" {
  name = "alias/kms-xac"
}
