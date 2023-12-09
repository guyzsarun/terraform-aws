resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  tags = {
    Name = "allow_ssh"
    Type = "ingress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
  security_group_id = aws_security_group.allow_ssh.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

}

resource "aws_security_group" "allow_vpc_ingress" {
  name        = "allow_vpc_ingress"
  description = "Allow inbound vpc traffic"
  vpc_id      = aws_vpc.main-vpc.id

  tags = {
    Name = "allow_vpc_ingress"
    Type = "ingress"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_vpc_ingress_rule" {
  security_group_id = aws_security_group.allow_vpc_ingress.id

  ip_protocol = "-1"
  cidr_ipv4   = aws_vpc.main-vpc.cidr_block

}



resource "aws_security_group" "allow_egress" {
  name        = "allow_egress"
  description = "Allow ALL outbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  tags = {
    Name = "allow_egress"
    Type = "egress"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_rule" {
  security_group_id = aws_security_group.allow_egress.id

  ip_protocol = -1
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_rule_ipv6" {
  security_group_id = aws_security_group.allow_egress.id

  ip_protocol = -1
  cidr_ipv6   = "::/0"
}