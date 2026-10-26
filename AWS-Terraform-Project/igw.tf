
# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-gateway" }
}
# Route Tables
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "public_RT" }
}

resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "private_RT" }
}

# Private Route via NAT
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_RT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Associate Subnets
resource "aws_route_table_association" "pub1_assoc" {
  subnet_id      = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.public_RT.id
}
resource "aws_route_table_association" "pub2_assoc" {
  subnet_id      = aws_subnet.pub_subnet2.id
  route_table_id = aws_route_table.public_RT.id
}
resource "aws_route_table_association" "priv1_assoc" {
  subnet_id      = aws_subnet.priv_subnet1.id
  route_table_id = aws_route_table.private_RT.id
}
resource "aws_route_table_association" "priv2_assoc" {
  subnet_id      = aws_subnet.priv_subnet2.id
  route_table_id = aws_route_table.private_RT.id
}
