variable "calc_overrides" {
  description    = "release_link -> {variables}"
  default        = {
    alpha        = {}
    beta         = {
      chart      = "astra-calc-server"
      is_enabled = false
      version    = "1.2.3"
    }
  }
}

variable "calc_defaults" {
  description  = "default values for the calc servers"
  default      = {
    chart      = "default chart name"
    is_enabled = true
    version    = "1.0.0"
  }
}

locals {
  calc_variables = {
    for k,v in var.calc_overrides:
      # release link name
      k => {
        for dk, dv in var.calc_defaults:
          # get the override value, if dne use the default one
          dk => try(var.calc_overrides[k][dk], dv)
      }
  }
}

output "test" {
  value = local.calc_variables
}
