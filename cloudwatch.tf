resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = 7
}