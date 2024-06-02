terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2c"
  
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

resource "aws_key_pair" "minecraft-automation" {
  key_name   = "minecraft-automation"
  public_key = file("${path.module}/minecraft-automation.pub")
}

resource "aws_security_group" "minecraft-auto" {
  name        = "minecraft-auto"
  description = "Allow SSH and Minecraft Port connections"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "minecraft-auto"
  }
}

resource "aws_vpc_security_group_ingress_rule" "minecraft-auto_connect" {
  security_group_id = aws_security_group.minecraft-auto.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25565
  ip_protocol       = "tcp"
  to_port           = 25565
}

resource "aws_vpc_security_group_ingress_rule" "minecraft-auto_ssh" {
  security_group_id = aws_security_group.minecraft-auto.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow-all" {
  security_group_id = aws_security_group.minecraft-auto.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_instance" "app_server" {
  ami                    = "ami-05a6dba9ac2da60cb"
  instance_type          = "t4g.small"
  subnet_id              = aws_subnet.main.id
  key_name               = aws_key_pair.minecraft-automation.key_name
  vpc_security_group_ids = [aws_security_group.minecraft-auto.id]
  associate_public_ip_address = true

  tags = {
    Name = "Minecraft-Server-Automated"
  }
}

