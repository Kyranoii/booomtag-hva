# Aurora Subnet Group
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name = "${var.project_name}-${var.environment}-aurora-subnet-group"
  subnet_ids = [
    aws_subnet.private_db_az1.id,
    aws_subnet.private_db_az2.id,
    ]

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-subnet-group"
  }
}

# Aurora Cluster
resource "aws_rds_cluster" "aurora_cluster" {
  engine = "aurora-mysql"
  engine_version = "8.0"
  allow_major_version_upgrade = true
  database_name = var.db_name
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  storage_encrypted = true
  skip_final_snapshot = true
  deletion_protection = false
  enable_http_endpoint = true

  # master user and pass for db
  master_username = var.db_username
  master_password = aws_secretsmanager_secret_version.aurora_master_password_ver.secret_string

  depends_on = [
    aws_secretsmanager_secret_version.aurora_master_password_ver
  ]

  # Auto-scaling
  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 4
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-cluster"
  }
}

# Aurora Instance
resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier = "${var.project_name}-${var.environment}-aurora-instance"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  engine = "aurora-mysql"
  instance_class = "db.serverless"
  engine_version = "8.0"
  publicly_accessible = false

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-instance"
  }
}

output "aurora_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  value = aws_rds_cluster.aurora_cluster.reader_endpoint
}
