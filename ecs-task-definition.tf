resource "aws_ecs_task_definition" "task_todo" {
  family                   = "task-todo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::730335588602:role/role-acesso-ssm"
  task_role_arn            = "arn:aws:iam::730335588602:role/role-acesso-ssm"

  container_definitions = jsonencode([
    {
      name      = "todo-app"
      image     = "${var.ecr}/node-todo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])
}