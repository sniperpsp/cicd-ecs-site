# Projeto Terraform para Infraestrutura AWS

Este repositório contém a configuração do Terraform para provisionar uma infraestrutura AWS, incluindo um cluster ECS, Application Load Balancer, e outros recursos necessários. Além disso, inclui um workflow do GitHub Actions para automatizar a execução do Terraform.

## Estrutura do Repositório

- `alb.tf`: Configuração do Application Load Balancer (ALB) e seus recursos associados.
- `deployECS.yml`: Workflow do GitHub Actions para deploy no ECS.
- `ecr.tf`: Configuração do repositório ECR.
- `ecs-cluster.tf`: Configuração do cluster ECS.
- `ecs-service.tf`: Configuração do serviço ECS.
- `ecs-task-definition.tf`: Definição da tarefa ECS.
- `main.tf`: Configuração principal do Terraform.
- `sg.tf`: Configuração do Security Group.
- `subnet.tf`: Configuração das subnets.
- `task.tf`: Configuração da definição de tarefa e serviço ECS.
- `variables.tf`: Definição das variáveis usadas no Terraform.
- `vpc.tf`: Configuração da VPC e do Internet Gateway.
- `route53.tf`: Criação da Entrada DNS.

## Pré-requisitos

- Terraform v1.2.0 ou superior
- Conta AWS com permissões para criar os recursos necessários
- Configuração das credenciais AWS no GitHub Secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
 .
## Configuração do Workflow do GitHub Actions

O workflow do GitHub Actions (`.github/workflows/deployECS.yml`) automatiza a execução do Terraform para validar e aplicar as mudanças na infraestrutura.

### Passos do Workflow

1. **Checkout do Código**: Faz o checkout do código do repositório.
2. **Configuração do Terraform**: Configura a versão do Terraform.
3. **Configuração das Credenciais AWS**: Configura as credenciais AWS usando os segredos armazenados no GitHub.
4. **Inicialização do Terraform**: Inicializa o Terraform.
5. **Aplicação do Terraform**: Aplica as mudanças automaticamente.
6. **Build e Push das Imagens Docker**: Constrói e envia as imagens Docker para o ECR.
7. **Deploy no ECS**: Realiza o deploy da aplicação no ECS.
8. **Destruição da Infraestrutura** (opcional): Destrói a infraestrutura se solicitado.

## Como Usar

1. Clone o repositório:
   ```sh
   git clone https://github.com/sniperpsp/cicd-ecs-site.git
   cd seu-repositorio
   ```

2. Configure suas variáveis no arquivo `variables.tf` conforme necessário algumas das variaveis são secrets do github.

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

## Inputs

| Nome               | Descrição                          | Tipo   | Default                     | Obrigatório |
| ------------------ | ---------------------------------- | ------ | --------------------------- | ----------- |
| `tag_name`         | Nome da instância                  | string | `"CICD-todo"`               | não         |
| `tag_app`          | Nome da aplicação                  | string | `"CICD-todo"`               | não         |
| `tag_servico`      | Nome do serviço                    | string | `"CICD-todo"`               | não         |
| `ami`              | ID da AMI que será usada           | string | `"ami-0d91c802561cd4176"`   | não         |
| `instance_type_ec2`| Tipo da instância usada            | string | `"t3.micro"`                | não         |
| `meu_ip`           | Meu endereço IP atual              | string | `"45.228.245.0"`            | não         |
| `sg1`              | Nome do Security Group que será criado | string | `"SG-Terraform"`           | não         |
| `ecr`              | URL do repositório ECR             | string | `"730335588602.dkr.ecr.us-east-1.amazonaws.com"` | não |

## Outputs

Nenhum output definido.

## Contribuição

Sinta-se à vontade para abrir issues e pull requests para melhorias e correções.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).