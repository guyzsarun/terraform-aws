variable "eks-config" {
  type = object({
    name     = string
    version  = string
    min_node = number
    max_node = number
  })
}

variable "vpc_id" {
  type = string
}


variable "subnet_id" {
  type = list(string)
}