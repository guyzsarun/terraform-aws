resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "terraform-devops-key"
  public_key = var.ssh_key_pair
}

resource "aws_instance" "bastion-vm" {
  ami           = var.vm_ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key_pair.key_name
  monitoring    = true

  subnet_id = aws_subnet.main-vpc-subnet-public[0].id

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_egress.id
  ]
  tags = {
    Name = "bastion-vm"
  }
}


resource "aws_instance" "private-vm" {
  ami           = var.vm_ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key_pair.key_name
  monitoring    = true

  subnet_id = aws_subnet.main-vpc-subnet-private[0].id

  vpc_security_group_ids = [
    aws_security_group.allow_vpc_ingress.id,
    aws_security_group.allow_egress.id
  ]

  tags = {
    Name = "private-vm"
  }
}
