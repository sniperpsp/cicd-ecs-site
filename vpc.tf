# Criação da VPC nova para a EC2 junto com um Internet Gateway
resource "aws_vpc" "vpc2" {
  cidr_block = "172.0.0.0/16"

  enable_dns_support   = true # Habilitando suporte a DNS para uso no RDS
  enable_dns_hostnames = true # Habilitando suporte a DNS para uso no RDS
  # Outros parâmetros do VPC podem ser adicionados aqui

  tags = {
    Name    = var.tag_name
    App     = var.tag_app
    Servico = var.tag_servico
  }
}

resource "aws_internet_gateway" "igw_terraform" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "${var.tag_name}-igw"
  }
}

# Liberando a saída na route table da VPC criada
resource "aws_route" "default_route" {
  route_table_id         = aws_vpc.vpc2.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_terraform.id

  depends_on = [aws_internet_gateway.igw_terraform]
}