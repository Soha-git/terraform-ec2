

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

resource "tls_private_key" "aws" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws_key" {
  public_key = tls_private_key.aws.public_key_openssh
}
resource "local_file" "local" {
  filename        = "${path.module}/private.pem"
  content         = tls_private_key.aws.private_key_pem
  file_permission = "0600"

}

resource "aws_security_group" "nginx" {
  name        = "Web-site"
  description = " This is security gropu for ec2"
  vpc_id      = aws_vpc.vpc_application.id
  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port  = 8080
    to_port    = 8080
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "web-site" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.aws_key.key_name
  subnet_id              = aws_subnet.public_subnet["a"].id
  vpc_security_group_ids = [aws_security_group.nginx.id]

  depends_on = [
    aws_internet_gateway.igw
  ]
}