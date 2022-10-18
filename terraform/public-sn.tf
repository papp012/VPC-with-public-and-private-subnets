resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-public-subnet"
  }
}


resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "${var.prefix}-elastic-IP"
  }
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name        = "${var.prefix}-nat-gateway"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${var.prefix}-public-rt"
  }
}


resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}


resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "public_sg" {
  name        = "admin1-security-group"
  description = "Allow SSH, HHTP and HTTPS for public subnet"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["${local.my_ip}/32"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  } 

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    protocol = "tcp"
    to_port = 443
  } 

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
}