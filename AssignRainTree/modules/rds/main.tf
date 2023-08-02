provider "aws" {
  region = var.region
}

resource "aws_rds_cluster" "backend_rds_cluster" {
  count                 = var.workspace == "dev" ? 1 : 3
  engine                = "aurora-postgresql"
  engine_mode           = var.workspace == "dev" ? "serverless" : "provisioned"
  engine_version        = "5.14.postgres"
  database_name         = var.workspace == "dev" ? "dev_database" : "prod_database"
  master_username       = var.db_username
  master_password       = var.db_password
  skip_final_snapshot   = true
  backup_retention_period = var.db_backup_retention_period

  scaling_configuration {
    auto_pause    = var.workspace == "dev" ? true : false
    max_capacity  = var.workspace == "dev" ? 8 : 0
    min_capacity  = var.workspace == "dev" ? 2 : 2
  }

  tags = {
    Name = var.workspace == "dev" ? "dev-backend-db" : "prod-backend-db"
  }
}

resource "aws_rds_cluster_instance" "backend_rds_instance" {
  count               = var.workspace == "dev" ? 0 : 3
  cluster_identifier  = aws_rds_cluster.backend_rds_cluster[0].id
  instance_class      = var.workspace == "dev" ? "db.r7g.4xlarge" : "db.r7g.4xlarge"
  availability_zone   = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)

  tags = {
    Name = var.workspace == "dev" ? "dev-backend-db-instance" : "prod-backend-db-instance-${count.index}"
  }
}
