data "aws_kms_alias" "kms_xac_alias" {
  name = "alias/kms-xac"
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "dev-frontend-bucket"
  acl    = "private"
}

resource "aws_ecr_repository" "backend_ecr_repo" {
  name = "dev-backend-repo"
}

resource "aws_ecs_service" "backend_service" {
  name            = "dev-backend-service"
  cluster         = aws_ecs_cluster.backend_cluster.id
  task_definition = aws_ecs_task_definition.backend_task_definition.arn
  desired_count   = var.backend_desired_count

  deployment_controller {
    type = "ECS"
  }
}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family                   = "dev-backend-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = aws_ecr_repository.backend_ecr_repo.repository_url
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_lb" "backend_alb" {
  name               = "dev-backend-alb"
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  security_groups    = [aws_security_group.backend_sg.id]

  listener {
    port = 443
    protocol = "HTTPS" 
    certificate_arn = "SSL_CERTIFICATE_ARN" 
    ssl_policy = "ELBSecurityPolicy-2016-08"  
    default_action {
      target_group_arn = aws_lb_target_group.backend_target_group.arn
      type             = "forward"
    }
  }

  default_action {
    type = "redirect"
    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_security_group" "backend_sg" {
  name_prefix = "backend-sg-"
  vpc_id      = var.vpc_id

  # Allow inbound HTTPS access from the ALB
  ingress {
    description = "HTTPS access from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_lb.backend_alb.security_groups[0]]
  }

  # Allow outbound internet access for the backend 
  egress {
    description = "Internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "backend_target_group" {
  name_prefix       = "backend-tg-"
  port              = 80
  protocol          = "HTTP"
  vpc_id            = var.vpc_id

  health_check {
    path = "/health"
    port = "traffic-port"  #traffic-port for Fargate
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "backend_target_group_attachment" {
  target_group_arn = aws_lb_target_group.backend_target_group.arn
  target_id        = aws_ecs_service.backend_service.id
  port             = 80
}

resource "aws_s3_bucket" "file_storage_bucket" {
  bucket = "dev-file-storage-bucket"
  acl    = "private"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecs-task-execution-policy"
  description = "Policy for ECS task execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:GetObject"
        Resource = aws_s3_bucket.file_storage_bucket.arn  # ECS tasks to read from file_storage_bucket
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_rds_cluster" "dev_database_instance" {
  engine               = "aurora-postgresql"
  engine_mode          = "serverless"
  engine_version       = "5.14.postgres"
  database_name        = "dev_database"
  master_username      = var.db_username
  master_password      = var.db_password
  skip_final_snapshot  = true
  backup_retention_period = 7

  scaling_configuration {
    auto_pause = true
    max_capacity = 8
    min_capacity = 2
  }

  tags = {
    Environment = "DEV"
  }
}

resource "aws_rds_cluster" "prod_database_instance" {
  engine               = "aurora-postgresql"
  engine_version       = "5.14.postgres"
  database_name        = "prod_database"
  master_username      = var.db_username
  master_password      = var.db_password
  skip_final_snapshot  = true
  backup_retention_period = 35

  identifier = "prod-cluster"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  scaling_configuration {
    auto_pause = false
    max_capacity = 8
    min_capacity = 2
    class = "db.r7g.4xlarge"
  }

  storage_encrypted = true
  storage_encryption_kms_key_id = data.aws_kms_alias.kms_xac_alias.target_key_arn

  tags = {
    Environment = "PROD"
  }
}

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend_bucket.bucket
}

output "backend_ecr_repo_url" {
  value = aws_ecr_repository.backend_ecr_repo.repository_url
}

output "backend_alb_dns_name" {
  value = aws_lb.backend_alb.dns_name
}

output "database_endpoint" {
  value = aws_rds_cluster.prod_database_instance.endpoint
}

output "file_storage_bucket_name" {
  value = aws_s3_bucket.file_storage_bucket.bucket
}
