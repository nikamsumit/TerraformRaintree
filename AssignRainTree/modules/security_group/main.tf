provider "aws" {
  region = var.region
}

resource "aws_security_group" "backend_sg" {
  name_prefix = var.workspace == "dev" ? "dev-backend-sg-" : "prod-backend-sg-"
  vpc_id      = var.vpc_id

  # Allow inbound HTTPS access from the ALB
  ingress {
    description = "HTTPS access from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [var.backend_alb_sg_id]
  }

  # Allow outbound internet access for the backend service
  egress {
    description = "Internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
