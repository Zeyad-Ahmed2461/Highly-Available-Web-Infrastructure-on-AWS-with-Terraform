resource "aws_subnet" "priv_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = "us-east-1a"
  tags = { Name = "private_subnet-1" }
}

resource "aws_subnet" "priv_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = "us-east-1b"
  tags = { Name = "private_subnet-2" }
}

resource "aws_subnet" "pub_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "us-east-1a"
  tags = { Name = "public_subnet-1" }
}

resource "aws_subnet" "pub_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = "us-east-1b"
  tags = { Name = "public_subnet-2" }
}
