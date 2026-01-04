# Create ecs service
resource "aws_ecs_service" "app_service" {
  name = "${var.project_name}-${var.environment}-service"
  cluster = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type = "FARGATE"
  desired_count = 1

  enable_execute_command = true

  network_configuration {
    subnets = [
      aws_subnet.private_app_az1.id,
      aws_subnet.private_app_az2.id
    ]
    security_groups = [aws_security_group.app_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name = "app"
    container_port = 80
  }
  depends_on = [aws_lb_listener.app_listener]
}
