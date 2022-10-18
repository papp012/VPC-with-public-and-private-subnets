resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.prefix}-private-subnet"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.prefix}-private-rt"
  }
}


resource "aws_route_table_association" "private_rt_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}


resource "aws_route" "private_nat_gateway" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


resource "aws_security_group" "private_sg" {
  name        = "${var.prefix}-private-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["${local.my_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
