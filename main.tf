variable "regions" {
  default = ["del", "ewd", "hal"]
}

variable "files" {
  default = ["ctx", "conf", "ca"]
}

variable "aladdin_client" {
  default = "dev"
}



output "test" {
  value = {
  for region in var.regions:
  region => {
    kube_config = "~/${var.aladdin_client}_tkgi_${region}_config"
    kube_host   = "~/${var.aladdin_client}_tkgi_${region}_host"
    kube_ca     = "~/${var.aladdin_client}_tkgi_${region}_ca"
  }
  }
}
