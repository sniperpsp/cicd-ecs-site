resource "aws_ecs_service" "service_todo" {
  name            = "service-todo"
  cluster         = aws_ecs_cluster.cluster_todo.id
  task_definition = aws_ecs_task_definition.task_todo.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

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

resource "random_id" "suffix" {
  byte_length = 4
}