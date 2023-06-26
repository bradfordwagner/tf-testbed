variable "input" {
  default = ["a", "b", "c"]
}

locals {
  # iterate over input and create a amap
  # input = { for i, v in var.input : i => v }
  input = [ for i, v in var.input : "${i} ${v}" ]
}

output "test" {
  value = local.input
}
