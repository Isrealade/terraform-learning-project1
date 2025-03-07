variable "backend_instance_type" {
  description = "ec2 instance details"
  type = object({
    name  = string
    type  = string
    count = number
  })
}

variable "frontend_instance_type" {
  description = "ec2 instance details"
  type = object({
    name  = string
    type  = string
    count = number
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
    name     = string
    http     = string
    https    = string
    ssh      = string
    outgoing = string
  })
}

variable "security_group.http" {
  description = "enable inbound http traffic for ipv4"
}

variable "security_group.https" {
  description = "enable inbound https traffic for ipv4"
}

variable "security_group.outgoing" {
  description = "enable outgoing traffic"
}

variable "security_group.ssh" {
  description = "enable backend access through ssh"
}

variable "trevo_s3_bucket" {
  description = "Name of s3 bucket"
  type        = string
}

