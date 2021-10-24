provider "aws" {
    region = "me-south-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "server"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"

  tags = {
    Name = "test_ubuntu"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

