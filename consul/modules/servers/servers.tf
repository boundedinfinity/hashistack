terraform {
  required_version = ">= 1.1"

  required_providers {
    # https://registry.terraform.io/providers/kreuzwerker/docker/latest
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

variable "runtime_dir" {
  type = string
}

variable "name" {
  type    = string
  default = "consul-server"
}

variable "docker_tag" {
  type    = string
  default = "1.15.2"
}

variable "network_management" {
  type = any
}

variable "network_application" {
  type = any
}

variable "instance" {
  type = number
}

variable "datacenter" {
  type    = string
  default = "dc1"
}

variable "quorem" {
  type = number
}

locals {
  qname = "${var.name}-${var.instance}"
}

resource "local_file" "xdg_data_home" {
  content  = ""
  filename = "${var.runtime_dir}/${local.qname}/.local/.terraformignore"
}

resource "local_file" "consul_data" {
  content  = ""
  filename = "${var.runtime_dir}/${local.qname}/data/.terraformignore"
}

# https://hub.docker.com/_/consul
resource "docker_image" "server" {
  name = "hashicorp/consul:${var.docker_tag}"
}

resource "docker_container" "server" {
  image = docker_image.server.image_id
  name  = local.qname

  # networks_advanced {
  #   name = var.network_management.id
  # }

  networks_advanced {
    name = var.network_application.id
  }

  volumes {
    host_path      = dirname(local_file.consul_data.filename)
    container_path = "/consul/data"
  }

  volumes {
    host_path      = dirname(local_file.xdg_data_home.filename)
    container_path = "/root/.local"
  }

  env = [
    # "CONSUL_CLIENT_INTERFACE=eth0",
    # "CONSUL_BIND_INTERFACE=eth1",
    # "CONSUL_ALLOW_PRIVILEGED_PORTS=1",
  ]

  # https://developer.hashicorp.com/consul/docs/agent/config/cli-flags
  command = [
    "consul", "agent", "-server", "-ui",
    "-node=${local.qname}",
    "-bootstrap-expect=${var.quorem}",
    "-data-dir=/consul/data",
    "-datacenter=${var.datacenter}"
    # "-bind", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_application.ipam_config).subnet}\" | attr \"address\"}}'",
    # "-advertise", "'{{ GetPrivateInterfaces | include \"network\" \"${one(var.network_management.ipam_config).subnet}\" | attr \"address\"}}'"
  ]
}

output "hostname" {
  value =  docker_container.server.hostname
}
