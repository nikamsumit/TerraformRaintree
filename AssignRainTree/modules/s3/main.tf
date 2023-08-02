provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.frontend_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket" "file_storage_bucket" {
  bucket = var.file_storage_bucket_name
  acl    = "private"
}
