resource "aws_vpc" "vpc_application" {
  cidr_block = var.cidr_vpc
  enable_dns_hostnames = true
  tags = {
    "name" = "VPC-APP"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_application.id

  tags = {
    "Name" = "IG-VPC-Application"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each                = local.subnets.public
  vpc_id                  = aws_vpc.vpc_application.id
  availability_zone       = "us-east-1${each.key}"
  cidr_block              = each.value
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public_subnet1${each.key}"
  }

}

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.vpc_application.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_public_association" {
  for_each       = local.subnets.public
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.route_public.id

}