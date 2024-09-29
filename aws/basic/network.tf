# Providers

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

# Data

data "aws_availability_zones" "available" {
  state = "available"
}


# Resources

# Networking #

# Gateway

resource "aws_vpc" "app" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = local.common_tags
}

# Internet Gateway

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

  tags = local.common_tags
}

# Subnets

resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.public_subnet_cidr_blocks[0]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = true # VM's get public ip on launch
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = local.common_tags
}

resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.public_subnet_cidr_blocks[1]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = true # VM's get public ip on launch
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = local.common_tags
}

# Routing

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "app_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.app.id
}

# Security groups

resource "aws_security_group" "lb_sg" {
  name   = "nginx_lb_sg"
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags

  # HTTP inbound from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Any outbound to internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags

  # HTTP inbound from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Any outbound to internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

