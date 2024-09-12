# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                        = "Mern-VPC"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name                                        = "Mern-InternetGateway"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }

  depends_on = [aws_vpc.vpc]
}

# Private Subnets
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.private_subnet_cidr)
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name                                        = "Private Subnet ${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

# Public Subnets
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.public_subnet_cidr)
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name                     = "Public Subnet ${count.index + 1}"
    "kubernetes.io/role/elb" = 1
  }
}

# Public Route Table
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public Subnets Route Table"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public_route_table_assoc" {
  route_table_id = aws_route_table.public_subnet_rt.id
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public-subnet[count.index].id

  depends_on = [aws_route_table.public_subnet_rt]
}

# Elastic IP for NAT Gateway
resource "aws_eip" "eip" {}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet[0].id  # NAT Gateway should be in a public subnet

  depends_on = [aws_eip.eip]
}

# Private Route Table
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private Subnets Route Table"
  }
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private_route_table_assoc" {
  route_table_id = aws_route_table.private_subnet_rt.id
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private-subnet[count.index].id

  depends_on = [aws_route_table.private_subnet_rt]
}

# Security Group
resource "aws_security_group" "vpc_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider restricting this to specific IP ranges
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider restricting this to specific IP ranges
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider restricting this to specific IP ranges
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls_ssh"
  }
}
