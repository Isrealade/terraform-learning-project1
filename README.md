# Terraform AWS Infrastructure

## Overview
This Terraform configuration provisions an AWS infrastructure including a VPC, subnets, security groups, EC2 instances, an internet gateway, and an S3 bucket. The setup ensures a structured environment for deploying backend and frontend servers with proper security measures.

## Files Included
- **main.tf**: Defines the main infrastructure components.
- **variables.tf**: Declares variables used within the Terraform configuration.
- **terraform.tfvars**: Stores values for the declared variables.

## Prerequisites
Ensure you have the following before applying the Terraform configuration:
- AWS account with necessary IAM permissions
- Terraform installed on your local machine
- Configured AWS credentials

## Infrastructure Components

### Providers
This configuration uses the AWS provider:
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

### VPC
A Virtual Private Cloud (VPC) is created to provide an isolated network:
```hcl
resource "aws_vpc" "trevo_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}
```

### Subnets
Two public subnets are created in different availability zones:
```hcl
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.trevo_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2" 
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.trevo_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-3" 
  map_public_ip_on_launch = true
}
```

### Internet Gateway
An internet gateway is created to allow public access:
```hcl
resource "aws_internet_gateway" "trevo_internet_gateway" {
  vpc_id = aws_vpc.trevo_vpc.id
}
```

### Security Groups
A security group is configured to allow HTTP, HTTPS, and SSH access:
```hcl
resource "aws_security_group" "trevo_security_group" {
  name        = "allow_tls"
  description = "Allow HTTP/HTTPS traffic and SSH access"
  vpc_id      = aws_vpc.trevo_vpc.id
}
```
Ingress rules allow HTTP, HTTPS, and SSH traffic:
```hcl
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = aws_vpc.trevo_vpc.cidr_block
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
```
Egress rules allow outgoing traffic:
```hcl
resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_ipv4" {
  security_group_id = aws_security_group.trevo_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
```

### EC2 Instances
Backend and frontend servers are provisioned with security groups:
```hcl
resource "aws_instance" "backend_server" {
  ami           = "ami-09a9858973b288bdd"
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet1.id
  security_groups = [aws_security_group.trevo_security_group.id]
  count = 2
}

resource "aws_instance" "frontend_server" {
  ami           = "ami-09a9858973b288bdd"
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet1.id
  security_groups = [aws_security_group.trevo_security_group.id]
  count = 3
}
```

### S3 Bucket
An S3 bucket is created for storage:
```hcl
resource "aws_s3_bucket" "trevo_s3_bucket" {
  bucket_prefix = var.trevo_s3_bucket
}
```

## Variables
The `variables.tf` file defines configurable parameters for the infrastructure:
```hcl
variable "instance_type" {
  description = "ec2 instance details"
  type        = string
  default     = "t3.micro"
}

variable "vpc_name" {
  description = "Name of vpc"
  type        = string
  default     = "practice_vpc"
}

variable "subnet_name1" {
  description = "Name of subnet"
  type        = string
  default     = "practice_subnet"
}

variable "subnet_name2" {
  description = "Name of subnet"
  type        = string
  default     = "practice_subnet2"
}

variable "internet_gateway" {
  description = "Name of Internet gateway"
  type        = string
  default     = "Internet_gateway"
}

variable "security_group" {
  description = "Name of security group"
  type        = string
  default     = "security_group"
}

variable "trevo_s3_bucket" {
  description = "s3 bucket"
  type = string
  default = "Trevo s3 bucket"
}
```

## Usage
1. Initialize Terraform:
   ```sh
   terraform init
   ```
2. Validate the configuration:
   ```sh
   terraform validate
   ```
3. Plan the deployment:
   ```sh
   terraform plan
   ```
4. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
5. Destroy resources when no longer needed:
   ```sh
   terraform destroy -auto-approve
   ```

## Conclusion
This Terraform setup simplifies the provisioning of a secure AWS infrastructure, making it easy to deploy cloud resources in a structured and automated manner.

