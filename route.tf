# Create internet route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.booomtag_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.booomtag_igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public_az1_assoc" {
  subnet_id = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_az2_assoc" {
  subnet_id = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create private route table
resource "aws_route_table" "private_rt_az1" {
  vpc_id = aws_vpc.booomtag_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az1.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az1"
  }
}

resource "aws_route_table" "private_rt_az2" {
  vpc_id = aws_vpc.booomtag_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az2.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az2"
  }
}

resource "aws_route_table_association" "private_subnet_az1_assoc" {
  subnet_id  = aws_subnet.private_app_az1.id
  route_table_id = aws_route_table.private_rt_az1.id
}

resource "aws_route_table_association" "private_subnet_az2_assoc" {
  subnet_id  = aws_subnet.private_app_az2.id
  route_table_id = aws_route_table.private_rt_az2.id
}

resource "aws_route_table_association" "private_db_az1_assoc" {
  subnet_id      = aws_subnet.private_db_az1.id
  route_table_id = aws_route_table.private_rt_az1.id
}

resource "aws_route_table_association" "private_db_az2_assoc" {
  subnet_id      = aws_subnet.private_db_az2.id
  route_table_id = aws_route_table.private_rt_az2.id
}