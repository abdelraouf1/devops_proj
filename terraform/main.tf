terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.64.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# -------------------------
# Key Pair
# -------------------------

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

# -------------------------
# VPC
# -------------------------

resource "aws_vpc" "mainvpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "main-vpc"
  }
}

# -------------------------
# Public Subnet
# -------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "main-igw"
  }
}

# -------------------------
# Route Table
# -------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# -------------------------
# Route Table Association
# -------------------------

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# Security Group
# -------------------------

resource "aws_security_group" "main_sg" {
  name   = "main-sg"
  vpc_id = aws_vpc.mainvpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

# -------------------------
# EC2
# -------------------------

resource "aws_instance" "deploy" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [
    aws_security_group.main_sg.id
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "deployNM"
  }
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = "EC2_ECR_AUTH"
}

