variable "selected_region" {
  type        = string
  description = "Name of region"
}

variable "az_zones" {
  type = list(string)
}

variable "backend_instance_type" {
  description = "ec2 instance details"
  type = object({
    name  = string
    type  = string
    count = number
    ami   = string
  })
}

variable "frontend_instance_type" {
  description = "ec2 instance details"
  type = object({
    name  = string
    type  = string
    count = number
    ami   = string
  })
}

variable "vpc_name" {
  description = "The name of vpc"
  type        = string
}


variable "public_subnet_1" {
  description = "Name of subnet"
  type        = string
}

variable "public_subnet_2" {
  description = "Name of subnet"
  type        = string
}

variable "internet_gateway" {
  description = "Name of Internet gateway"
  type        = string
}

variable "security_group" {
  description = "Allow HTTP/HTTPS traffic for frontend servers and SSH access for backend servers"
  type = object({
    name     = string # Name of the security group
    http     = string # Enable inbound HTTP traffic for IPv4
    https    = string # Enable inbound HTTPS traffic for IPv4
    ssh      = string # Enable backend access through SSH
    outgoing = string # Enable outgoing traffic
  })
}

variable "trevo_s3_bucket" {
  description = "Name of s3 bucket"
  type        = string
}

variable "my_iam_user" {
  type = object({
    name        = string
    description = string
  })
}

variable "iam_policy" {
  type = object({
    policy_arn = string
  })
}

