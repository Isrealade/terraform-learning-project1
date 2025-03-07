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
    Name = var.public_subnet_1
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.trevo_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_2
  }
}

resource "aws_internet_gateway" "trevo_internet_gateway" {
  vpc_id = aws_vpc.trevo_vpc.id

  tags = {
    Name = var.internet_gateway
  }
}

resource "aws_security_group" "trevo_security_group" {
  name   = var.security_group.name
  vpc_id = aws_vpc.trevo_vpc.id

  tags = {
    Name = var.security_group.name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = aws_vpc.trevo_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    name = var.security_group.http
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = aws_vpc.trevo_vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    name = var.security_group.https
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_backend_access" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = aws_vpc.trevo_vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    name = var.security_group.ssh
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    name = var.security_group.outgoing
  }
}

resource "aws_instance" "backend_server" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.backend_instance_type.type
  vpc_security_group_ids = [aws_security_group.trevo_security_group.id]
  subnet_id              = aws_subnet.public_subnet1.id
  count                  = var.backend_instance_type.count

  tags = {
    Name = "${var.backend_instance_type.name}${count.index}"
  }
}

resource "aws_instance" "frontend_server" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.frontend_instance_type.type
  vpc_security_group_ids = [aws_security_group.trevo_security_group.id]
  subnet_id              = aws_subnet.public_subnet1.id
  count                  = var.frontend_instance_type.count

  tags = {
    Name = "${var.frontend_instance_type.name}${count.index}"
  }
}

resource "aws_s3_bucket" "trevo_bucket_s3" {
  bucket = var.trevo_s3_bucket


  tags = {
    Name = var.trevo_s3_bucket
  }
}