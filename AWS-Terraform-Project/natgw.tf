# NAT EIP
resource "aws_eip" "nat_eip" {
  tags = { Name = "nat-eip" }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet1.id
  tags = { Name = "nat-gateway" }
}

