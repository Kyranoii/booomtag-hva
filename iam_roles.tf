# ECS Task Execution Role (used by ECS to pull images, write logs, and access secrets)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-ecs-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect  = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach the default ECS Task Execution Role managed policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role  = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom policy to allow pulling images from ECR
resource "aws_iam_policy" "ecs_execution_ecr_policy" {
  name = "${var.project_name}-${var.environment}-ecs-exec-ecr-policy"
  description = "Allow ECS task execution role to pull images from ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach ECR policy to the execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_attach_ecr" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_ecr_policy.arn
}

# Custom policy to allow ECS to read secrets from Secrets Manager
resource "aws_iam_policy" "ecs_execution_secrets_policy" {
  name = "${var.project_name}-${var.environment}-ecs-exec-secrets-policy"
  description = "Allow ECS task execution role to retrieve Aurora DB secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.aurora_master_password.arn
        ]
      }
    ]
  })
}

# Attach Secrets Manager policy to the execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_attach_secrets" {
  role  = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_secrets_policy.arn
}

# Custom policy to allow ECS to write logs to CloudWatch
resource "aws_iam_policy" "ecs_execution_logs_policy" {
  name = "${var.project_name}-${var.environment}-ecs-exec-logs-policy"
  description = "Allow ECS task execution role to write to CloudWatch logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach CloudWatch Logs policy to the execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_attach_logs" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_logs_policy.arn
}

# ECS Task Role (used by the running container to access AWS resources)
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach a managed policy (for example, RDS Data API access)
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}
