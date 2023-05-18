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

variable "user" {
  type = string
}

variable "name" {
  type    = string
  default = "consul-server"
}

variable "image" {
  type = string
}

variable "tag" {
  type = string
}

variable "network" {
  type = any
}

variable "runtime_dir" {
  type = string
}

variable "environment" {
  type    = list(string)
  default = []
}

variable "command" {
  type = list(string)
}

variable "publish_all_ports" {
  type    = bool
  default = false
}

variable "volumes" {
  type = list(object({
    host_path      = string
    container_path = string
  }))
}

variable "ports" {
  type = list(object({
    internal = string
    external = optional(string)
    protocol = optional(string)
    ip       = optional(string)
  }))
}

locals {
  xdg_root = "${var.runtime_dir}/${var.name}"
}

locals {
  all_volumes = concat([]
    # [{
    #   host_path      = local.xdg_root
    #   container_path = "/root/.local"
    # }],
    # var.volumes
  )
}

module "ensure_xdg" {
  source = "../ensure_xdg"
  root   = local.xdg_root
}

resource "docker_image" "image" {
  name = "${var.image}:${var.tag}"
}

resource "docker_container" "container" {
  image = docker_image.image.image_id
  name  = var.name
  # user  = var.user

  publish_all_ports = var.publish_all_ports

  networks_advanced {
    name = var.network.id
  }

  dynamic "volumes" {
    for_each = local.all_volumes
    content {
      host_path      = volumes.value.host_path
      container_path = volumes.value.container_path
    }
  }

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      protocol = ports.value.protocol
      ip       = ports.value.ip
    }
  }

  env     = var.environment
  command = var.command
}

output "hostname" {
  value = docker_container.container.hostname
}

# output "ipv4" {
#   value = docker_container.container.network_data.ipv4[0]
# }
