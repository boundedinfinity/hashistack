

variable "runtime_dir" {
  type = string
}

variable "instance" {
  type = number
}

variable "datacenter" {
  type = string
}

variable "quorem" {
  type = number
}

variable "network_application" {
  type = any
}

variable "name" {
  type    = string
  default = "consul-server"
}

module "common" {
  source              = "../common"
  name                = var.name
  network_application = var.network_application
  runtime_dir         = var.runtime_dir
  datacenter          = var.datacenter
  instance            = var.instance

  # https://developer.hashicorp.com/consul/docs/agent/config/cli-flags
  command = [
    "consul", "agent", "-server", "-ui",
    "-node=${var.name}-${var.instance}",
    "-bootstrap-expect=${var.quorem}",
    "-data-dir=/consul/data",
    "-datacenter=${var.datacenter}"
    # "-bind", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_application.ipam_config).subnet}\" | attr \"address\"}}'",
    # "-advertise", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_management.ipam_config).subnet}\" | attr \"address\"}}'"
  ]
}

output "hostname" {
  value = module.common.hostname
}