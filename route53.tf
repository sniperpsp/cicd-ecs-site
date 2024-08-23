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

resource "aws_route53_record" "db" {
  zone_id = "Z09315943W3HUYZ1CG61C"  # ID da zona existente
  name    = "banco-todo.trustcompras.com.br"
  type    = "A"
  ttl     = 60

  records = [aws_instance.db_instance.public_ip]  # Placeholder para o IP do container/task
}