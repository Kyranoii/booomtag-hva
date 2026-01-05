# Create new vpc
resource "aws_vpc" "booomtag_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "booomtag_igw" {
  vpc_id = aws_vpc.booomtag_vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# Create AZs dynamically
data "aws_availability_zones" "available" {
  state = "available"
}

# Create public subnets
resource "aws_subnet" "public_subnet_az1" {
  vpc_id = aws_vpc.booomtag_vpc.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-az1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id = aws_vpc.booomtag_vpc.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-az2"
  }
}

# Create private subnets
resource "aws_subnet" "private_app_az1" {
  vpc_id = aws_vpc.booomtag_vpc.id
  cidr_block = var.private_app_az1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-az1"
  }
}

resource "aws_subnet" "private_app_az2" {
  vpc_id = aws_vpc.booomtag_vpc.id
  cidr_block = var.private_app_az2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-az2"
  }
}

resource "aws_subnet" "private_db_az1" {
  vpc_id = aws_vpc.booomtag_vpc.id
  cidr_block = var.private_db_az1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-db-az1"
  }
}

resource "aws_subnet" "private_db_az2" {
  vpc_id = aws_vpc.booomtag_vpc.id
  cidr_block = var.private_db_az2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-db-az2"
  }
}




