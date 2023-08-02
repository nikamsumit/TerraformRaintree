provider "aws" {
  region = var.region
}

resource "aws_lb" "backend_alb" {
  name               = var.workspace == "dev" ? "dev-backend-alb" : "prod-backend-alb"
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  security_groups    = [var.backend_alb_sg_id]

  listener {
    port = 443
    protocol = "HTTPS"
    certificate_arn = var.ssl_certificate_arn
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

resource "aws_lb_target_group" "backend_target_group" {
  name_prefix       = var.workspace == "dev" ? "dev-backend-tg-" : "prod-backend-tg-"
  port              = 80
  protocol          = "HTTP"
  vpc_id            = var.vpc_id

  health_check {
    path = "/health"
    port = "traffic-port"
    protocol = "HTTP"
  }
}
