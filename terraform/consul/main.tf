
variable "user" {
  type = string
}

variable "consul_server_count" {
  type    = number
  default = 5
  validation {
    condition     = var.consul_server_count >= 3
    error_message = "consul_server_count must be >= 3"
  }
}

variable "consul_server_quorem" {
  type    = number
  default = 3
  validation {
    condition     = var.consul_server_quorem >= 3
    error_message = "consul_server_quorem must be >= 3 and consul_server_quorem must be <= consul_server_count"
  }
}

variable "consul_client_count" {
  type    = number
  default = 1
}

variable "consul_datacenter" {
  type    = string
  default = "hashistack"
}

locals {
  runtime_dir = abspath("${path.root}/../.runtime")
  count_list  = range(1, var.consul_server_count)
}

module "networks" {
  source = "../networks"
}

module "server0" {
  source              = "./server"
  user                = var.user
  instance            = 0
  network_application = module.networks.application
  runtime_dir         = local.runtime_dir
  datacenter          = var.consul_datacenter
  quorem              = var.consul_server_quorem
  # network_management  = module.networks.management
}

module "serverN" {
  source              = "./server"
  user                = var.user
  for_each            = toset([for v in local.count_list : tostring(v)])
  instance            = each.value
  network_application = module.networks.application
  runtime_dir         = local.runtime_dir
  datacenter          = var.consul_datacenter
  quorem              = var.consul_server_quorem
  retry_join          = module.server0.hostname
  # network_management  = module.networks.management
}

module "client" {
  source              = "./client"
  user                = var.user
  count               = var.consul_client_count
  instance            = count.index
  network_application = module.networks.application
  runtime_dir         = local.runtime_dir
  datacenter          = var.consul_datacenter
  retry_join          = module.server0.hostname
  # network_management  = module.networks.management
}
