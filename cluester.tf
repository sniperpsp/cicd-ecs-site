resource "aws_ecs_cluster" "cluster-todo" {
  name = "cluster-todo"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/clustes-todo"
  retention_in_days = 5
}