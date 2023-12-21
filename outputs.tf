output "bastion-vm" {
  value = {
    id         = module.bastion.id
    private_ip = module.bastion.private_ip
    public_ip  = module.bastion.public_ip
  }
}

output "private-bastion-vm" {
  value = {
    id         = module.private_bastion.id
    private_ip = module.private_bastion.private_ip
  }
}


output "nat-gateway" {
  value = {
    public_ip  = module.vpc.aws_nat_gateway.public_ip
    private_ip = module.vpc.aws_nat_gateway.private_ip
  }
}
