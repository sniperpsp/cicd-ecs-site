resource "aws_ecs_cluster" "cluster_todo" {
  name = "cluster-todo"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/cluster-todo"
  retention_in_days = 5
}