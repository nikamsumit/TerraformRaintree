provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "backend_cluster" {
  name = var.workspace == "dev" ? "dev-backend-cluster" : "prod-backend-cluster"
}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family                   = var.workspace == "dev" ? "dev-backend-task" : "prod-backend-task"
  execution_role_arn       = var.backend_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = var.backend_ecr_repo_url
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

resource "aws_ecs_service" "backend_service" {
  name            = var.workspace == "dev" ? "dev-backend-service" : "prod-backend-service"
  cluster         = aws_ecs_cluster.backend_cluster.id
  task_definition = aws_ecs_task_definition.backend_task_definition.arn
  desired_count   = var.backend_desired_count

  deployment_controller {
    type = "ECS"
  }
}
