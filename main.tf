variable "regions" {
  default = ["del", "ewd", "hal"]
}

variable "files" {
  default = ["ctx", "conf", "ca"]
}

variable "aladdin_client" {
  default = "dev"
}

variable "mi6_labels" {
  default = {
    groups      = ["group1", "group2"]
    owners      = ["owner1", "owner2"]
    team        = "team"
    environment = "dev"
  }
}

locals {
#  consul_mi6_vars = {
    #    "server.extraLabels"
    #    "client.extraLabels"
#  }

  //    APP_NAME: AstraKafkaBroker0
  //    BATCH: group
  //    ENVIRONMENT: dev
  //    Kubernetes_APP: group
  //    NAMESPACE: astra
  //    OWNER1: jrossi
  //    OWNER2: mayhtim
  //    OWNER3: apinkhas
  //    Team: GroupDataOpsAstraDev
#  consul_mi6_vars = merge(
#  {for t in toset(["server", "client"]):
#    "${t}.extraLabels" =>
#      merge({
#        Team     = var.mi6_labels.team,
#        APP_NAME = "consul_${t}",
#      },
#      { for g in var.mi6_labels.groups:
#        g => "group"
#      }, { for i,o in var.mi6_labels.owners:
#        "OWNER${i+1}" => o
#      })
#  })
  # create an object that corresponds to:
  #  APP_NAME: AstraKafkaBroker0
  #  BATCH: group
  #  ENVIRONMENT: dev
  #  Kubernetes_APP: group
  #  NAMESPACE: astra
  #  OWNER1: jrossi
  #  OWNER2: mayhtim
  #  OWNER3: apinkhas
  #  Team: GroupDataOpsAstraDev
  consul_obj = merge({
    Team        = var.mi6_labels.team,
    ENVIRONMENT = var.mi6_labels.environment
  },
  { for g in var.mi6_labels.groups:
    g => "group"
  }, { for i,o in var.mi6_labels.owners:
    "OWNER${i+1}" => o
  })
  # map to helm variables for client to create extra labels
  consul_mi6_client_vars = merge({
    for k,v in local.consul_obj:
      "client.extraLabels.${k}" => v
  }, {
    "client.extraLabels.APP_NAME" = "ConsulClient"
  })
  # map to helm variables for server to create extra labels
  consul_mi6_server_vars = merge({
    for k,v in local.consul_obj:
      "server.extraLabels.${k}" => v
  }, {
    "server.extraLabels.APP_NAME" = "ConsulServer"
  })
  // flatten out to single map
  consul_mi6_vars = merge(local.consul_mi6_client_vars, local.consul_mi6_server_vars)
}


output "test" {
  value = local.consul_mi6_vars
#  value = local.consul_obj
}
