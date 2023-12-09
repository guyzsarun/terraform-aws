variable "vm_ami" {
  default = "ami-02453f5468b897e31"
}

variable "aws_credentials" {
  sensitive = true
  type = object({
    access_key = string
    secret_key = string
    region     = string
  })
}

variable "ssh_key_pair" {
  type = string
}

variable "eks-config" {
  type = object({
    name = string
    version = string
    min_node = number
    max_node = number
  })
}