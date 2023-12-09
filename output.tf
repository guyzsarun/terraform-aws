output "bastion-vm" {
  value = {
    name              = aws_instance.bastion-vm.tags_all["Name"]
    availability_zone = aws_instance.bastion-vm.availability_zone
    private_ip        = aws_instance.bastion-vm.private_ip
    public_ip         = aws_instance.bastion-vm.public_ip
  }
}

output "private-vm" {
  value = {
    name              = aws_instance.private-vm.tags_all["Name"]
    availability_zone = aws_instance.private-vm.availability_zone
    private_ip        = aws_instance.private-vm.private_ip
    public_ip         = aws_instance.private-vm.public_ip
  }
}

output "nat-gateway" {
  value = {
    public_ip = aws_nat_gateway.nat-gw.public_ip
    private_ip = aws_nat_gateway.nat-gw.private_ip
  }
}

output "eks"{
  value = {
    cluster_name = module.eks.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    get_kubeconfig_command = "aws eks update-kubeconfig --name ${module.eks.cluster_name}"
  }
}