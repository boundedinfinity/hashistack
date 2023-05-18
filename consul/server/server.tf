
variable "user" {
  type = string
}

variable "runtime_dir" {
  type = string
}

variable "instance" {
  type = string
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

variable "retry_join" {
  type    = string
  default = ""
}

locals {
  base_command = [
    "consul", "agent", "-server", "-ui",
    "-node=${var.name}-${var.instance}",
    "-bootstrap-expect=${var.quorem}",
    "-data-dir=/consul/data",
    "-datacenter=${var.datacenter}"
    # "-bind", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_application.ipam_config).subnet}\" | attr \"address\"}}'",
    # "-advertise", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_management.ipam_config).subnet}\" | attr \"address\"}}'"
  ]
}

locals {
  command = var.retry_join != "" ? concat(local.base_command, ["-retry-join=${var.retry_join}"]) : local.base_command
}

module "common" {
  source              = "../common"
  name                = var.name
  network_application = var.network_application
  runtime_dir         = var.runtime_dir
  datacenter          = var.datacenter
  instance            = var.instance
  user                = var.user

  # https://developer.hashicorp.com/consul/docs/agent/config/cli-flags
  command = local.command
}

output "hostname" {
  value = module.common.hostname
}
