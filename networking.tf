resource "aws_vpc" "cloudlab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "cloudlab-sandbox"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "sim_internet_subnet" {
  vpc_id                  = aws_vpc.cloudlab_vpc.id
  cidr_block              = var.sim_internet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "simulated_internet_subnet"
  }
}

resource "aws_subnet" "dmz_subnet" {
  vpc_id                  = aws_vpc.cloudlab_vpc.id
  cidr_block              = var.dmz_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "DMZ_subnet"
  }
}

resource "aws_subnet" "on_prem_subnet" {
  vpc_id                  = aws_vpc.cloudlab_vpc.id
  cidr_block              = var.on_prem_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "on_premises_subnet"
  }
}

resource "aws_internet_gateway" "cloudlab_igw" {
  vpc_id = aws_vpc.cloudlab_vpc.id

  tags = {
    Name = "cloudlab_igw"
  }
}

resource "aws_route_table" "cloudlab_rt" {
  vpc_id = aws_vpc.cloudlab_vpc.id

  tags = {
    Name = "cloudlab_rt"
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.cloudlab_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloudlab_igw.id
}

resource "aws_route_table_association" "sim_subnet_assoc" {
  subnet_id      = aws_subnet.sim_internet_subnet.id
  route_table_id = aws_route_table.cloudlab_rt.id
}

resource "aws_route_table_association" "on_prem_subnet_assoc" {
  subnet_id      = aws_subnet.on_prem_subnet.id
  route_table_id = aws_route_table.cloudlab_rt.id
}

resource "aws_route_table_association" "dmz_subnet_assoc" {
  subnet_id      = aws_subnet.dmz_subnet.id
  route_table_id = aws_route_table.cloudlab_rt.id
}

resource "aws_security_group" "cloudlab_sg" {
  name        = "cloudlab_sg"
  description = "Allow ALL traffic from your PUBLIC IP & VPC"
  vpc_id      = aws_vpc.cloudlab_vpc.id

  ingress {
    description = "ALL traffic from your PUBLIC IP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_ip]
  }

  ingress {
    description = "ALL traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudlab_sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}
