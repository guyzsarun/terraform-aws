module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "module-vpc"
}

module "bastion" {
  source       = "./modules/vm"
  ssh_key_pair = var.ssh_key_pair

  vm_name   = "bastion_vm"
  subnet_id = module.vpc.public_subnet_id[0]

  init_script = "./helper/init.sh"

  security_group_ids = [
    module.vpc.security_group_allow_ssh,
    module.vpc.security_group_allow_egress
  ]
}

module "private_bastion" {
  source       = "./modules/vm"
  ssh_key_pair = var.ssh_key_pair

  vm_name   = "private_vm"
  subnet_id = module.vpc.private_subnet_id[0]

  security_group_ids = [
    module.vpc.security_group_allow_ssh,
    module.vpc.security_group_allow_egress
  ]
}