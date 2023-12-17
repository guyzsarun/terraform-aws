resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
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
    Name = "main-vpc-${data.aws_availability_zones.available.names[count.index]}-private"
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
    Name = "main-vpc-${data.aws_availability_zones.available.names[count.index]}-public"
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
    Name = "main-vpc-public-routetable"
  }
}

resource "aws_route_table" "main-vpc-private-routetable" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "main-vpc-private-routetable"
  }
}

resource "aws_route_table_association" "route-assoc-private" {
  subnet_id      = aws_subnet.main-vpc-subnet-private[count.index].id
  route_table_id = aws_route_table.main-vpc-private-routetable.id
  count          = length(aws_subnet.main-vpc-subnet-private)


  depends_on = [aws_subnet.main-vpc-subnet-private]
}

resource "aws_route_table_association" "route-assoc-public" {
  subnet_id      = aws_subnet.main-vpc-subnet-public[count.index].id
  route_table_id = aws_route_table.main-vpc-public-routetable.id
  count          = length(aws_subnet.main-vpc-subnet-public)


  depends_on = [aws_subnet.main-vpc-subnet-public]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "internet-gw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat"
  }
}


resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main-vpc-subnet-public[0].id

  tags = {
    Name = "nat-gw"
  }

  depends_on = [aws_internet_gateway.gw]
}