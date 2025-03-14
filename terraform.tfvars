selected_region = "eu-north-1"

az_zones = [
  "eu-north-1a", "eu-north-1b"
]

backend_instance_type = {
  count = 4
  type  = "t3.micro"
  name  = "backend_server_"
  ami   = "ami-09a9858973b288bdd"
}

frontend_instance_type = {
  count = 2
  name  = "frontend_server_"
  type  = "t3.micro"
  ami   = "ami-09a9858973b288bdd"
}

vpc_name = "public_vpc"

public_subnet_1 = "az1_subnet"

public_subnet_2 = "az2_subnet"

internet_gateway = "public_internet_gateway"

security_group = {
  name     = "security_group"
  http     = "ipv4 http"
  https    = "ipv4_https"
  ssh      = "ssh_access"
  outgoing = "outgoing_traffic"
}

trevo_s3_bucket = "trevo-s3-bucket"

my_iam_user = {
  name        = "BOB"
  description = "CTO"
}

iam_policy = {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}