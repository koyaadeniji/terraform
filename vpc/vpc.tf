
resource "aws_vpc" "myvpc" {
  cidr_block           = "120.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "myNetwork"
  }
}


resource "aws_subnet" "mysub" {
  vpc_id                   = aws_vpc.myvpc.id
  cidr_block               = "120.0.10.0/24"
  map_public_ip_on_launch  = "true"

  tags = {
    Name = "mysubNet"
  }
}


resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "myRoute"
  }
}


resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myIGW"
  }
}


resource "aws_route_table_association" "myRTass" {
  subnet_id      = aws_subnet.mysub.id
  route_table_id = aws_route_table.myroute.id
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.myvpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}



