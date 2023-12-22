resource "aws_efs_file_system" "private-nfs" {
  creation_token  = "private-nfs"
  throughput_mode = "elastic"


  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "private-nfs-data"
  }
}


resource "aws_efs_backup_policy" "private-nfs-policy" {
  file_system_id = aws_efs_file_system.private-nfs.id

  backup_policy {
    status = "DISABLED"
  }
}

resource "aws_efs_mount_target" "private-nfs-mount" {
  file_system_id  = aws_efs_file_system.private-nfs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.allow_vpc_ingress.id]

  for_each = { for index, i in aws_subnet.main-vpc-subnet-private : index => i.id }
}