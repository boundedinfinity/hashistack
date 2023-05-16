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

variable "volumes" {
  type = object({
    host_path      = string
    container_path = string
  })
}

locals {
  xdg_root = "${var.runtime_dir}/${var.name}"
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

  networks_advanced {
    name = var.network.id
  }

  volumes {
    host_path      = local.xdg_root
    container_path = "/root/.local"
  }

  volumes {
    host_path      = var.volumes.host_path
    container_path = var.volumes.container_path
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
