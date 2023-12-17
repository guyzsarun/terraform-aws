module "bastion" {
  source       = "./modules/vm"
  ssh_key_pair = var.ssh_key_pair

  vm_name   = "bastion_vm"
  subnet_id = aws_subnet.main-vpc-subnet-public[0].id

  init_script = "./helper/init.sh"

  security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_egress.id
  ]
}

module "private_bastion" {
  source       = "./modules/vm"
  ssh_key_pair = var.ssh_key_pair

  vm_name   = "private_vm"
  subnet_id = aws_subnet.main-vpc-subnet-private[0].id

  security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_egress.id
  ]
}