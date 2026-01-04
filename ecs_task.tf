# Create ECS task
resource "aws_ecs_task_definition" "app_task" {
  family = "${var.project_name}-${var.environment}-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "16384"
  memory = "32768"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name = "app"
    image = "${aws_ecr_repository.app_repo.repository_url}:latest"
    essential = true

    portMappings = [
      {
        containerPort = 80
        hostPort = 80
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = "/ecs/${var.project_name}-${var.environment}"
        awslogs-region = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }

    environment = [
      {
        name = "DB_HOST"
        value = aws_rds_cluster.aurora_cluster.endpoint
      },
      {
        name = "DB_NAME"
        value = var.db_name
      },
      {
        name = "DB_USER"
        value = var.db_username
      }
    ]

    secrets = [
      {
        name = "DB_PASSWORD"
        valueFrom = aws_secretsmanager_secret.aurora_master_password.arn
      }
    ]

  }])
}
