resource "aws_ecs_task_definition" "todo" {
    family = "nodeo-todo"
    network_mode = "awsvpc"
    cpu = "512"
    memory = "1024"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn = "arn:aws:iam::730335588602:role/role-acesso-ssm"

    container_definitions = jsonencode([
    {
        name   = "node-todo",
        #image = "nginx:latest"
        image  = aws_ecr_repository.node_todo.repository_url,
        cpu     =   256,
        memory  =   512,
        essential   = true,
        portMappings    =   [{containerPort = 80, hostPort = 80}],
        logConfiguration = {
            logDriver = "awslogs",
            options = {
                "awslogs-group"     =   aws_cloudwatch_log_group.log_group.name,
                "awslogs-region"    =   "us-east-1",
                "awslogs-stream-prefix" = "ecs"

            }
        }
    }
   ])
}

resource "aws_ecs_service" "todo_service" {
    name =  "node_todo"
    cluster = aws_ecs_cluster.cluster_todo.id
    task_definition = aws_ecs_task_definition.todo.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]
      security_groups = [aws_security_group.SG1.id]
      assign_public_ip = true
    }

    load_balancer {

      target_group_arn = aws_lb_target_group.node-todo.arn
      container_name = "node-todo"
      container_port =  80

    }

    depends_on = [ 
        aws_ecs_cluster.cluster_todo,
        aws_ecr_repository.node_todo,
        aws_lb.lb_todo,

        ]
  
}