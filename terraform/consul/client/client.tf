variable "user" {
  type = string
}

variable "runtime_dir" {
  type = string
}

variable "instance" {
  type = number
}

variable "datacenter" {
  type = string
}

variable "network_application" {
  type = any
}

variable "name" {
  type    = string
  default = "consul-client"
}

variable "retry_join" {
  type = string
}

locals {
  labels = [
    {
      label = "consul"
      value = "client"
    }
  ]
}

module "common" {
  source              = "../common"
  name                = var.name
  network_application = var.network_application
  runtime_dir         = var.runtime_dir
  datacenter          = var.datacenter
  instance            = var.instance
  user                = var.user
  labels              = local.labels

  # https://developer.hashicorp.com/consul/docs/agent/config/cli-flags
  command = [
    "consul", "agent", "-ui",
    "-node=${var.name}-${var.instance}",
    "-data-dir=/consul/data",
    "-datacenter=${var.datacenter}",
    "-retry-join=${var.retry_join}",
    # "-bind", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_application.ipam_config).subnet}\" | attr \"address\"}}'",
    # "-advertise", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_management.ipam_config).subnet}\" | attr \"address\"}}'"
  ]
}

output "hostname" {
  value = module.common.hostname
}
