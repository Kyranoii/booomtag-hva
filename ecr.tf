# Create private ECR reposistory to store Docker image
resource "aws_ecr_repository" "app_repo" {
  name = "${var.project_name}-${var.environment}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-repo"
    Environment = var.environment
  }
}

# Clean up old images
resource "aws_ecr_lifecycle_policy" "cleanup_policy" {
  repository = aws_ecr_repository.app_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description = "Expire untagged images older than 14 days"
        selection = {
          tagStatus = "untagged"
          countType = "sinceImagePushed"
          countUnit = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}