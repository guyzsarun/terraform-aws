resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "main-vpc-subnet-private" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  count                   = 3
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[count.index]}-private"
    Type = "private"
  }
}

resource "aws_subnet" "main-vpc-subnet-public" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.${count.index + 4}.0/24"
  count                   = 3
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[count.index]}-public"
    Type = "public"
  }
}

resource "aws_route_table" "main-vpc-public-routetable" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-routetable"
  }
}

resource "aws_route_table" "main-vpc-private-routetable" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${var.vpc_name}-private-routetable"
  }
}

resource "aws_route_table_association" "route-assoc-private" {
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main-vpc-private-routetable.id
  for_each = { for i, subnet in aws_subnet.main-vpc-subnet-private : subnet.id => subnet }
}

resource "aws_route_table_association" "route-assoc-public" {
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main-vpc-public-routetable.id
  for_each = { for i, subnet in aws_subnet.main-vpc-subnet-public : subnet.id => subnet }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.vpc_name}-internet-gw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-nat"
  }
}


resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main-vpc-subnet-public[0].id

  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.gw]
}