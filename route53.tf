resource "aws_route53_record" "app" {
  zone_id = "Z09315943W3HUYZ1CG61C"  # ID da zona existente
  name    = "app-todo.trustcompras.com.br"
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}

data "aws_ecs_task" "task_todo" {
  cluster = aws_ecs_cluster.cluster_todo.id
  task_id = aws_ecs_service.service_todo.task_definition
}

resource "aws_route53_record" "db" {
  zone_id = "Z09315943W3HUYZ1CG61C"  # ID da zona existente
  name    = "banco-todo.trustcompras.com.br"
  type    = "A"
  ttl     = 60

  records = [data.aws_ecs_task.task_todo.network_interface[0].private_ip]
}