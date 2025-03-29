provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "app_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}



resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block             = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}



resource "aws_security_group" "app_sg" {
    name        = "${var.project_name}-sg"
    description = "Security group for ${var.project_name} EC2 instance"
    vpc_id      = aws_vpc.app_vpc.id

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip_cidr]
    }

    ingress {
        description = "Allow Port 8000"
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow Port 3000"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
            Name = "${var.project_name}-sg"
    }
}

resource "aws_key_pair" "app_key" {
    key_name   = "${var.project_name}-key"
    public_key = file(var.public_key_path)
}

resource "aws_instance" "app_server" {
    ami                    = var.ami
    instance_type          = var.instance_type
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    key_name               = aws_key_pair.app_key.key_name
    subnet_id              = aws_subnet.public_subnet.id

    user_data = templatefile("${path.module}/dockerInstall.tpl",{})
    tags = {
        Name = "${var.project_name}-server"
    }
}

output "ec2_public_ip" {
    description = "Public IP of the EC2 instance"
    value       = aws_instance.app_server.public_ip
}

output "ec2_public_dns" {
    description = "Public DNS of the EC2 instance"
    value       = aws_instance.app_server.public_dns
}