provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "backend_ecr_repo" {
  name = var.backend_ecr_repo_name
}
