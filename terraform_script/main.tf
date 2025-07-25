provider "aws" {
  region = var.region
}

resource "aws_vpc" "mb_hcl_hack" {
  cidr_block = var.cidr_block

}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)
  vpc_id            = aws_vpc.mb_hcl_hack.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Public-Subnet ${count.index}"
  }
  
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  vpc_id            = aws_vpc.mb_hcl_hack.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    "Name" = "Private-Subnet ${count.index}"
  }
  
}

resource "aws_internet_gateway" "mb_hcl_igw" {
  vpc_id = aws_vpc.mb_hcl_hack.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.mb_hcl_hack.id

  tags = {
    Name = "my-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mb_hcl_igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.mb_hcl_hack.id

  tags = {
    Name = "my-private-rt"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "my-nw"
  }
}

resource "aws_eip" "my_eip" {
  domain = "vpc"
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id

  depends_on = [ aws_eip.my_eip ]
}