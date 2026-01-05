# Security Group for the Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name = "${var.project_name}-${var.environment}-alb-sg"
  description = "Allow internet access to the ALB"
  vpc_id = aws_vpc.booomtag_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# Security Group for ECS Fargate containers
resource "aws_security_group" "app_sg" {
  name  = "${var.project_name}-${var.environment}-app-sg"
  description = "Allow only ALB traffic to ECS tasks"
  vpc_id = aws_vpc.booomtag_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project_name}-${var.environment}-app-sg"
  }
}


# Security Group for Aurora Cluster
resource "aws_security_group" "aurora_sg" {
  name  = "${var.project_name}-${var.environment}-aurora-sg"
  description = "Aurora DB access only from ECS tasks"
  vpc_id = aws_vpc.booomtag_vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-sg"
  }
}

