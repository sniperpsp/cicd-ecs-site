# Aqui temos as variáveis que estou utilizando, você pode criar mais variáveis para facilitar no script.

variable "tag_name" {
  description = "Nome da instância"
  type        = string
  default     = "CICD-todo"
}

variable "tag_app" {
  description = "Nome da aplicação"
  type        = string
  default     = "CICD-todo"
}

variable "tag_servico" {
  description = "Nome do serviço"
  type        = string
  default     = "CICD-todo"
}

variable "ami" {
  description = "ID da AMI que será usada"
  type        = string
  default     = "ami-0d91c802561cd4176"
}

variable "instance_type_ec2" {
  description = "Tipo da instância usada"
  type        = string
  default     = "t3.micro"
}

variable "meu_ip" {
  description = "Meu endereço IP atual"
  type        = string
  default     = "45.228.245.0"  # Substitua pelo seu endereço IP atual para ser liberado a fazer SSH na máquina
}

variable "sg1" {
  description = "Nome do Security Group que vai ser criado"
  type        = string
  default     = "SG-Terraform"
}

variable "aws_account_id" {
  description = "Secret Github com o AWS Account ID"
  type        = string
}

variable "ecr_uri" {
  description = "Secret Github com o URI do repositório ECR"
  type        = string
}
