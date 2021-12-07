variable "astra_calc_cluster_overrides" {
  description = "release_link -> {variables}"
  default = {
    alpha = {}
    beta = {
      astra_calc_server_chart_version = "1234"
    }
  }
}


variable "astra_calc_cluster_defaults" {
  default = {
    # calc
    astra_calc_server_chart_version            = "9.32.12"
    astra_calc_server_release                  = "test-astra-calc-server"
    astra_calc_server_release_link             = "beta-universe"
    astra_calc_server_chart                    = "astra-calc-server"
    astra_calc_server_error_only_logging       = true
    astra_calc_server_enable_partitioning      = true
    astra_calc_server_enable_kafka_logging     = false
    astra_calc_server_enable_track_and_commit  = false
    astra_calc_server_enable_trace_logging     = false
    astra_calc_server_disable_purge_block      = false
    astra_calc_server_purge_wait_msec_per_1000 = 0
    astra_calc_server_enable_sync_kafka_commit = true
    # ui
    astra_ui_chart_version                     = "7.14.0"
    astra_ui_chart                             = "astra-ui"
    astra_ui_release                           = "astra-ui"
    astra_ui_permission_check                  = "true"
    astra_ui_mtls_enabled                      = "true"
  }
  type = object({
    astra_calc_server_chart_version            = string
    astra_calc_server_chart                    = string
    astra_calc_server_error_only_logging       = bool
    astra_calc_server_enable_partitioning      = bool
    astra_calc_server_enable_kafka_logging     = bool
    astra_calc_server_enable_track_and_commit  = bool
    astra_calc_server_enable_trace_logging     = bool
    astra_calc_server_disable_purge_block      = bool
    astra_calc_server_purge_wait_msec_per_1000 = number
    astra_calc_server_enable_sync_kafka_commit = bool
    # ui
    astra_ui_chart_version                     = string
    astra_ui_chart                             = string
    astra_ui_release                           = string
    astra_ui_permission_check                  = string
    astra_ui_mtls_enabled                      = string
  })
}

locals {
  calc_variables = {
  for k, v in var.astra_calc_cluster_overrides:
    # release link name
    k => merge({
      for dk, dv in var.astra_calc_cluster_defaults:
        # get the override value, if dne use the default one
        dk => try(var.astra_calc_cluster_overrides[k][dk], dv)
      }, {
        # setup release link uniquely
        astra_release_link        = format("%s-universe"  , k)
        astra_calc_server_release = format("astra-calc-%s", k)
        astra_ui_release          = format("astra-ui-%s", k)
      })
  }
}

output "test" {
  value = local.calc_variables
}
