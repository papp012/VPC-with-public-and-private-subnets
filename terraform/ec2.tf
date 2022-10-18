resource "aws_instance" "public-ec2" {
  ami = var.ami_ID
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.prefix}-public-instance"
  }
}


resource "aws_instance" "private-ec2" {
  ami = var.ami_ID
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "${var.prefix}-private-instance"
  }
}