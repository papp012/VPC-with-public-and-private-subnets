resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.prefix}-private-subnet"
  }
}

