provider "aws" {
  region = "eu-central-1"
}

locals {
  workers_nodes = 3
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.240.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "K8S Test"
  }
}

# Network
resource "aws_internet_gateway" "default_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Default Gateway"
  }
}

resource "aws_route_table" "default_public_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default_gw.id
  }
}

resource "aws_route" "r" {
  count = local.workers_nodes
  route_table_id         = aws_route_table.default_public_route.id
  destination_cidr_block = "10.200.${count.index}.0/24"
  instance_id            = aws_instance.workers[count.index].id
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.240.0.0/24"
  tags = {
    Name = "Public Network"
  }
  availability_zone = "eu-central-1a"
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.default_public_route.id
}

# Security Groups
resource "aws_security_group" "cluster" {
  name        = "K8s Cluster"
  description = "K8s Cluster"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Free for all inside the local net
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "10.240.0.0/24",
      "10.200.0.0/16"
    ]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # HTTPS
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # ICMP
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "Cluster"
  }

}

resource "aws_security_group" "api" {
  name        = "K8s Api Balancer"
  description = "K8s Api Balancer"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "Api Load Balancer"
  }

}

# Key
resource "aws_key_pair" "ssh_key" {
  key_name   = "k8s-test-ssh-key"
  public_key = file("${path.module}/../secrets/id_rsa.pub")
}

## EC2 Instances
resource "aws_instance" "controllers" {
  count                       = 3
  key_name                    = aws_key_pair.ssh_key.key_name
  instance_type               = "t3.2xlarge"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  ebs_optimized = true
  monitoring = true
  private_ip = "10.240.0.1${count.index}"

  vpc_security_group_ids = [aws_security_group.cluster.id]
  ami                    = "ami-0767046d1677be5a0"

  root_block_device {
    volume_size           = "200"
    delete_on_termination = true
  }

  tags = {
    Name = "controller-${count.index}"
    Role = "Controller"
  }

}

resource "aws_instance" "workers" {
  count                       = 3
  key_name                    = aws_key_pair.ssh_key.key_name
  instance_type               = "t3.2xlarge"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  ebs_optimized = true
  monitoring = true
  private_ip = "10.240.0.2${count.index}"

  vpc_security_group_ids = [aws_security_group.cluster.id]
  ami                    = "ami-0767046d1677be5a0"

  root_block_device {
    volume_size           = "200"
    delete_on_termination = true
  }

  tags = {
    Name = "worker-${count.index}"
    Role = "Worker"
  }
}

resource "aws_elb" "api" {
  name = "api"

  security_groups = [aws_security_group.api.id]
  subnets = [
    aws_subnet.public.id
  ]

  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:6443"
    interval            = 30
  }

  instances                   = aws_instance.controllers.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "Api"
  }
}
