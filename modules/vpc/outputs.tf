output "vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "private_subnet_id" {
  value = aws_subnet.main-vpc-subnet-private.*.id
}

output "public_subnet_id" {
  value = aws_subnet.main-vpc-subnet-public.*.id
}

output "security_group_allow_ssh" {
  value = aws_security_group.allow_ssh.id
}

output "security_group_allow_egress" {
  value = aws_security_group.allow_egress.id
}

output "aws_nat_gateway" {
  value = {
    public_ip  = aws_nat_gateway.nat-gw.public_ip
    private_ip = aws_nat_gateway.nat-gw.private_ip
  }

}