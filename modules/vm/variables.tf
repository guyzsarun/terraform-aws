variable "ssh_key_pair" {
  type      = string
  sensitive = true
}

variable "vm_ami" {
  default = "ami-02453f5468b897e31" #amazon linux
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vm_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "init_script" {
  type    = string
  default = null
}