resource "aws_route53_record" "app" {
  zone_id = "Z09315943W3HUYZ1CG61C"  # ID da zona existente
  name    = "gpt.trustcompras.com.br"
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}

# O registro DNS para o banco de dados será atualizado pelo script update_dns.sh