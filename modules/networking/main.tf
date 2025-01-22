provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "11.0.0.0/24"
  
  tags = {
    Name = "custom_vpc"
  }
}

resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "11.0.0.0/26"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "11.0.0.64/26"  # Corrected CIDR block

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "rt_public"
  }
}

resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.custom_igw.id
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "rt_private"
  }
}

resource "aws_route" "route_private" {
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id  # Corrected attribute
}

resource "aws_route_table_association" "to_public_subnet" {
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "to_private_subnet" {
  route_table_id = aws_route_table.rt_private.id
  subnet_id      = aws_subnet.private_subnet.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id

  depends_on = [aws_internet_gateway.custom_igw] 

  tags = {
    Name = "nat_gateway"
  }
}
