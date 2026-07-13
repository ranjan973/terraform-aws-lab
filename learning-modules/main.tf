provider "aws" {
  region = "us-west-2"
}

provider "vault" {
  address          = "http://192.168.11.201:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "a6515138-e43b-34f6-6719-2774f3dae9b5"
      secret_id = "5bec7472-f44e-0bf2-6ef7-96e495de9880"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

/*module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  cidr = var.vpc_cidr
  name = var.vpc_name

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  tags               = var.vpc_tags

}*/

data "vault_kv_secret_v2" "example" {
  mount = "secret"
  name  = "test-secret"

}

resource "aws_instance" "example" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"


  tags = {
    Name   = "Test"
    secret = data.vault_kv_secret_v2.example.data["username"]
  }
}

