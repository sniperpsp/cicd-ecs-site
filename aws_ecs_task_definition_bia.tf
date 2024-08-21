resource "aws_ecs_task_definition" "bia-web" {
  family       = "task-def-bia"
  network_mode = "bridge"
  task_role_arn = "arn:aws:iam::730335588602:role/role-acesso-ssm"

  container_definitions = jsonencode([
    {
      name      = "todo"
      image     = "${var.ecr}/node-todo-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 0
        }
      ]
      cpu               = 256
      memoryReservation = 200
      environment = [
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "DB_HOST"
          value = "db"
        },
        {
          name  = "DB_SECRET_NAME"
          value = ""
        },
        {
          name  = "DB_REGION"
          value = "us-east-1"
        },
        {
          name  = "DEBUG_SECRET"
          value = "true"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = "us-east-1"
          awslogs-group         = "/ecs/bia-web"
          awslogs-stream-prefix = "bia"
        }
      }
    },
    {
      name      = "db"
      image     = "${var.ecr}/postgres-db:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 0
        }
      ]
      cpu               = 256
      memoryReservation = 200
      environment = [
        {
          name  = "POSTGRES_USER"
          value = "postgres"
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = "postgres"
        },
        {
          name  = "POSTGRES_DB"
          value = "postgres"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = "us-east-1"
          awslogs-group         = "/ecs/bia-web"
          awslogs-stream-prefix = "db"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}