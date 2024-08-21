# Projeto Terraform para Infraestrutura AWS

Este repositório contém a configuração do Terraform para provisionar uma infraestrutura AWS, incluindo um cluster ECS, Auto Scaling Group, Load Balancer, e outros recursos necessários. Além disso, inclui um workflow do GitHub Actions para automatizar a execução do Terraform.

## Estrutura do Repositório

- `alb.tf`: Configuração do Application Load Balancer (ALB) e seus recursos associados.
- `asg_ecs_bia_web.tf`: Configuração do Auto Scaling Group (ASG) para o cluster ECS.
- `aws_ecs_capacity_provider.tf`: Configuração do ECS Capacity Provider.
- `aws_ecs_service_bia.tf`: Configuração do serviço ECS.
- `aws_ecs_task_definition_bia.tf`: Definição da tarefa ECS.
- `aws_launch_template.tf`: Template de lançamento para instâncias EC2.
- `ecr.tf`: Configuração do repositório ECR.
- `ecs.tf`: Configuração do cluster ECS.
- `main.tf`: Configuração principal do Terraform.
- `sg.tf`: Configuração do Security Group.
- `subnet.tf`: Configuração das subnets.
- `variables.tf`: Definição das variáveis usadas no Terraform.
- `vpc.tf`: Configuração da VPC e do Internet Gateway.

## Pré-requisitos

- Terraform v1.2.0 ou superior
- Conta AWS com permissões para criar os recursos necessários
- Configuração das credenciais AWS no GitHub Secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

## Configuração do Workflow do GitHub Actions

O workflow do GitHub Actions (`.github/workflows/terraform.yml`) automatiza a execução do Terraform para validar e aplicar as mudanças na infraestrutura.

### Passos do Workflow

1. **Checkout do Código**: Faz o checkout do código do repositório.
2. **Configuração do Terraform**: Configura a versão do Terraform.
3. **Configuração das Credenciais AWS**: Configura as credenciais AWS usando os segredos armazenados no GitHub.
4. **Inicialização do Terraform**: Inicializa o Terraform.
5. **Validação do Terraform**: Valida a configuração do Terraform.
6. **Plano do Terraform**: Gera um plano de execução do Terraform.
7. **Aplicação do Terraform** (opcional): Aplica as mudanças automaticamente (descomentado se necessário).

## Como Usar

1. Clone o repositório:
   ```sh
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio
   ```

2. Configure suas variáveis no arquivo `variables.tf` conforme necessário.

3. Inicialize o Terraform:
   ```sh
   terraform init
   ```

4. Valide a configuração do Terraform:
   ```sh
   terraform validate
   ```

5. Gere um plano de execução:
   ```sh
   terraform plan
   ```

6. Aplique as mudanças:
   ```sh
   terraform apply
   ```

## Contribuição

Sinta-se à vontade para abrir issues e pull requests para melhorias e correções.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
