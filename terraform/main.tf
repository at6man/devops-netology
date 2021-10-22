terraform {
    backend "s3" {
        bucket = "at6man-terraform-states"
        encrypt = true
        key = "main-infra/terraform.tfstate"
        region = "me-south-1"
        dynamodb_table = "terraform-locks"
    }
}

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

resource "aws_instance" "server" {
    ami = data.aws_ami.ubuntu.id
    # instance_type = "t3.micro"
    instance_type = local.server_instance_type_map[terraform.workspace]
    count = local.server_instance_count_map[terraform.workspace]
    lifecycle {
        create_before_destroy = true
    }
    tags = {
        Name = "test_ubuntu"
    }
}

resource "aws_instance" "server_2" {
    for_each = local.server_instance_type_map
    ami = data.aws_ami.ubuntu.id
    instance_type = each.value
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

