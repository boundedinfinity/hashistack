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
  type = string
}

variable "docker_tag" {
  type    = string
  default = "1.15.2"
}

variable "docker_image" {
  type    = string
  default = "hashicorp/consul"
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

variable "environment" {
  type    = list(string)
  default = []
}

variable "command" {
  type = list(string)
}

locals {
  qname    = "${var.name}-${var.instance}"
  data_dir = "${var.runtime_dir}/${local.qname}/data"
}

module "ensure_dir" {
  source = "../../ensure_dir"
  path   = local.data_dir
}

module "docker" {
  source      = "../../docker"
  name        = local.qname
  image       = var.docker_image
  tag         = var.docker_tag
  network     = var.network_application
  runtime_dir = var.runtime_dir

  volumes = {
    host_path      = local.data_dir
    container_path = "/consul/data"
  }

  environment = var.environment

  # https://developer.hashicorp.com/consul/docs/agent/config/cli-flags
  command = var.command
}

output "hostname" {
  value = module.docker.hostname
}
