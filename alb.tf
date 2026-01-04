# Create Application Load Balancer
resource "aws_lb" "app_alb" {
  name  = "${var.project_name}-${var.environment}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_subnet_az1.id,
    aws_subnet.public_subnet_az2.id
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
  }
}

# Create Target Group
resource "aws_lb_target_group" "app_tg" {
  name = "${var.project_name}-${var.environment}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.booomtag_vpc.id
  target_type = "ip"

  health_check {
    path = "/health"
    port = "80"
    protocol = "HTTP"
    interval = 30
    timeout = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

# Create Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
