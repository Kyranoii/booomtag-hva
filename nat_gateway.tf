# Create NAT gateway
resource "aws_eip" "nat_eip_az1" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip-az1"
  }
}

resource "aws_eip" "nat_eip_az2" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip-az2"
  }
}

resource "aws_nat_gateway" "nat_az1" {
  allocation_id = aws_eip.nat_eip_az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-az1"
  }
}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat_eip_az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-az2"
  }
}