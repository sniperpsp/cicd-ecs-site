resource "aws_ecs_task_definition" "task_todo" {
  family                   = "task-todo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/role-acesso-ssm"
  task_role_arn            = "arn:aws:iam::${var.aws_account_id}:role/role-acesso-ssm"

  container_definitions = jsonencode([
    {
      name      = "todo-app"
      image     = "${var.ecr_uri}/node-todo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PGHOST"
          value = "banco.trustcompras.com.br"  # Use o nome do serviço do banco de dados
        },
        {
          name  = "PGUSER"
          value = "postgres"
        },
        {
          name  = "PGPASSWORD"
          value = "postgres"
        },
        {
          name  = "PGDATABASE"
          value = "postgres"
        },
        {
          name  = "PGPORT"
          value = "5432"
        },
        {
          name  = "DEPLOYMENT_TIME"
          value = timestamp()  # Adiciona um timestamp para forçar a criação de uma nova versão da tarefa
        }
      ]
    },
    {
      name      = "banco-de-dados"
      image     = "${var.ecr_uri}/banco-de-dados:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]
    }
  ])
}