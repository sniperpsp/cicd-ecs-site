resource "aws_lb_target_group" "node-todo" {
  name = "albtodo"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc2.id

  target_type = "ip"

  health_check {
    
    enabled  = true
    path    = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }  

  tags = {
    App = var.tag_app
    Name = var.tag_name
    Servico= var.tag_servico
  }
}
resource "aws_lb" "lb_todo" {
  name  = "lbtodo"
  internal  = false
  load_balancer_type = "application"
  subnets = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]
  security_groups = [aws_security_group.SG1.id]
  
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb_todo.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.node-todo.arn
  }

}