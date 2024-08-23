resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG1.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name    = var.tag_name
    App     = var.tag_app
    Servico = var.tag_servico
  }
}

resource "aws_lb_target_group" "node_todo" {
  name     = "albtodo"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc2.id

  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    App     = var.tag_app
    Name    = var.tag_name
    Servico = var.tag_servico
  }
}

resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:${var.aws_account_id}:certificate/49375b4a-4966-4d12-84c3-d17869bb4488"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node_todo.arn
  }
}