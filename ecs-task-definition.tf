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
          value = "banco-de-dados"
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

resource "aws_ecs_service" "task_todo" {
  name            = "service-todo"
  cluster         = aws_ecs_cluster.cluster_todo.id
  task_definition = aws_ecs_task_definition.task_todo.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_groups  = [aws_security_group.SG1.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.node_todo.arn
    container_name   = "todo-app"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.lb_listener_https
  ]
}