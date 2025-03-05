variable "instance_type" {
  description = "ec2 instance details"
  type        = string
  default = "t3.micro"
}

variable "vpc_name" {
  description = "Name of vpc"
  type        = string
  default     = "practice_vpc"
}

variable "public_subnet_name1" {
  description = "Name of subnet"
  type        = string
  default     = "practice_subnet"
}

variable "public_subnet_name2" {
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
  description = "Allow HTTP/HTTPS traffic for frontend servers and SSH access for backend servers"
  type        = string
  default     = "security_group"
}

variable "allow_http_ipv4" {
  description = "enable inbound http traffic for ipv4"
  type        = string
  default     = "ipv4 http"
}

variable "allow_https_ipv4" {
  description = "enable inbound https traffic for ipv4"
  type        = string
  default     = "ipv4 https"
}

variable "allow_backend_access" {
  description = "enable backend access through ssh"
  type        = string
  default     = "ssh access"
}

variable "backend_server" {
  description = "backend server"
  type        = string
  default     = "backend_server"
}

variable "frontend_server" {
  description = "frontend server"
  type        = string
  default     = "frontend_server"
}

variable "trevo_s3_bucket" {
  description = "s3 bucket"
  type        = string
  default     = "trevo-s3-bucket"
}