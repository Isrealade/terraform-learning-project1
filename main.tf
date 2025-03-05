terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "trevo_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.trevo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name1
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.trevo_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name2
  }
}

resource "aws_internet_gateway" "trevo_internet_gateway" {
  vpc_id = aws_vpc.trevo_vpc.id

  tags = {
    Name = var.internet_gateway
  }
}

resource "aws_security_group" "trevo_security_group" {
  name   = var.security_group
  vpc_id = aws_vpc.trevo_vpc.id

  tags = {
    Name = var.security_group
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = aws_vpc.trevo_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    name = var.allow_http_ipv4
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = aws_vpc.trevo_vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    name = var.allow_https_ipv4
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "allow_backend_access" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = aws_vpc.trevo_vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    name = var.allow_backend_access
  }
}

resource "aws_instance" "backend_server" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.trevo_security_group.id]
  subnet_id              = aws_subnet.public_subnet1.id
  count                  = 2

  tags = {
    Name = "backend_server_${count.index}"
  }
}

resource "aws_instance" "frontend_server" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.trevo_security_group.id]
  subnet_id              = aws_subnet.public_subnet1.id
  count                  = 3

  tags = {
    Name = "frontend_server_${count.index}"
  }
}

resource "aws_s3_bucket" "trevo_bucket_s3" {
  bucket = var.trevo_s3_bucket


  tags = {
    Name = var.trevo_s3_bucket
  }
}