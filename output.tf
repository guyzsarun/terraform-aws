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