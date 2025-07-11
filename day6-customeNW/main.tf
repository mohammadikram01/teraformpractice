
# VPC
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "customVPC"
  }
}

# Subnet
resource "aws_subnet" "name" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  map_public_ip_on_launch = true # Important!
  tags = {
    Name = "subnet1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "IG"
  }
}

# Route Table
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "publicRouteT"
  }
}

# Route (0.0.0.0/0 via IGW)
resource "aws_route" "name" {
  route_table_id         = aws_route_table.name.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.name.id
}

# Subnet-Route Table Association
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}

# Security Group
resource "aws_security_group" "name" {
  name        = "allow_all"
  vpc_id      = aws_vpc.name.id
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG"
  }
}

# EC2 Instance
resource "aws_instance" "name" {
  ami                    = "ami-05ffe3c48a9991133" # Amazon Linux 2 in us-east-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.name.id
  vpc_security_group_ids = [aws_security_group.name.id]
  associate_public_ip_address = true


  tags = {
    Name = "server"
  }
}
