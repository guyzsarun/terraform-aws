resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "${var.vm_name}-key"
  public_key = var.ssh_key_pair
}

resource "aws_instance" "vm" {
  ami           = var.vm_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_key_pair.key_name
  monitoring    = true

  subnet_id = var.subnet_id

  user_data = var.init_script != null ? file(var.init_script) : null

  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = var.vm_name
  }
}