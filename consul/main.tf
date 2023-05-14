
variable "consul_server_count" {
  type    = number
  default = 5
}

variable "consul_server_quorem" {
  type    = number
  default = 3
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
}

module "networks" {
  source = "./modules/networks"
}

module "server" {
  source              = "./modules/servers"
  count               = var.consul_server_count
  instance            = count.index
  network_management  = module.networks.management
  network_application = module.networks.application
  runtime_dir         = local.runtime_dir
  datacenter          = var.consul_datacenter
  quorem              = var.consul_server_quorem
}
