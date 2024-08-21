resource "aws_ecs_task_definition" "bia-web" {
  family       = "task-def-bia"
  network_mode = "bridge"
  task_role_arn = "arn:aws:iam::730335588602:role/role-acesso-ssm"

  container_definitions = jsonencode([
    {
      name      = "todo"
      image     = "${aws_ecr_repository.todo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0
        }
      ]
      cpu               = 1024
      memoryReservation = 400
      environment = [
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "DB_HOST"
          value = ""
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
          awslogs-group         = "/ecs/bia-web"  // Adicionando awslogs-group
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "bia"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

}