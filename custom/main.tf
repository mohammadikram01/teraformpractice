#privateserver
resource "aws_instance" "pvtserver" {
  ami = "ami-05ffe3c48a9991133"
  instance_type = "t2.nano"
  subnet_id = aws_subnet.privatesubnet.id
  vpc_security_group_ids = [aws_security_group.name.id]
  key_name = "pvtkey"
  tags = {Name = "pvtServerr"}

}
#publicserver
resource "aws_instance" "publicserver" {
  ami = "ami-05ffe3c48a9991133"
  instance_type = "t2.nano"
  subnet_id = aws_subnet.publicsubnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.name.id]

  tags = {Name = "pubServer"}

}
#customvpc
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {Name= "customeVpc"}
}
#subnetpub
resource "aws_subnet" "publicsubnet" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.name.id
  tags = {Name="pubsubnet"}

}
#subnetpvt
resource "aws_subnet" "privatesubnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.name.id
  tags = {Name="pvtsubnet"}

}
#ig
resource "aws_internet_gateway" "InternetGatway" {
  vpc_id = aws_vpc.name.id
  
  tags = {Name= "InternetGatway"}
}
#nat
resource "aws_nat_gateway" "natgatway" {
  subnet_id = aws_subnet.publicsubnet.id
  allocation_id = aws_eip.nat_eip.id
  tags = {Name="natgatway"}
  depends_on = [ aws_internet_gateway.InternetGatway,aws_eip.nat_eip ]
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
#routetable1pub
resource "aws_route_table" "publicroute" {
    vpc_id = aws_vpc.name.id
    tags = {Name="publicroute"}
}
#routetable2pvt
resource "aws_route_table" "pvtroute" {
  vpc_id = aws_vpc.name.id
  tags = {Name= "pvtroute"}
}
#subnetassociationforpub
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.publicroute.id
  subnet_id = aws_subnet.publicsubnet.id
}
#subnetassociationforpvt
resource "aws_route_table_association" "name2" {
  route_table_id = aws_route_table.pvtroute.id
  subnet_id = aws_subnet.privatesubnet.id
}
#route
resource "aws_route" "routeinternetG" {
  route_table_id = aws_route_table.publicroute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.InternetGatway.id

}
#route
resource "aws_route" "routenat" {
  route_table_id = aws_route_table.pvtroute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.natgatway.id
}
#sg
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
resource "aws_s3_bucket" "name1" {
  bucket = "statefilebucket100"
  tags = {Name= "bucket" }
  

}

