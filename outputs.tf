output "bastion-vm" {
  value = {
    id              = module.bastion.id
    private_ip        = module.bastion.private_ip
    public_ip         = module.bastion.public_ip
  }
}

output "private-bastion-vm" {
  value = {
    id              = module.private_bastion.id
    private_ip        = module.private_bastion.private_ip
  }
}


# output "eks" {
#   value = {
#     cluster_name           = module.eks.cluster_name
#     cluster_endpoint       = module.eks.cluster_endpoint
#     get_kubeconfig_command = "aws eks update-kubeconfig --name ${module.eks.cluster_name}"
#   }
# }