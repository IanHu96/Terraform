terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.17.0"
    }
  }
}

provider "azurerm" {
  features {}
  shared_credentials_file = 
}

terraform {
  backend "s3" {
    bucket = "drift-demo"
    key    = "drift"
    region = "us-east-1"
  }
}


resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_demo_sg.id]
  # Render the User Data script as a template
  user_data = templatefile("user-data.sh", {
    server_port = var.server_port
  })
  tags = {
    Name = "Created_By_Terraform_Automation"
  }
}



resource "aws_security_group" "ec2_demo_sg" {
  name        = "ec2_demo_allowhttp"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = var.server_port
    to_port          = var.server_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}