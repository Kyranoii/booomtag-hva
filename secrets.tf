# Store ECS credentials securely in AWS Secrets Manager
resource "aws_secretsmanager_secret" "ecs_task_credentials" {
  name = "${var.project_name}-${var.environment}-ecs-credentials-1.4"
  description = "ecs credentials"
}

resource "aws_secretsmanager_secret_version" "master_crendtials" {
  secret_id = aws_secretsmanager_secret.ecs_task_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

# Store Aurora DB credentials securely in AWS Secrets Manager
resource "aws_secretsmanager_secret" "aurora_master_password" {
  name = "${var.project_name}-${var.environment}-aurora-password-2"
  description = "Aurora password"
}

resource "aws_secretsmanager_secret_version" "aurora_master_password_ver" {
  secret_id     = aws_secretsmanager_secret.aurora_master_password.id
  secret_string = var.db_password  
}




