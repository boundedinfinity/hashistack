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

# https://hub.docker.com/_/consul
# https://hub.docker.com/r/hashicorp/consul
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
  source            = "../../docker"
  name              = local.qname
  image             = var.docker_image
  tag               = var.docker_tag
  network           = var.network_application
  runtime_dir       = var.runtime_dir
  user              = var.user
  environment       = var.environment
  # publish_all_ports = true

  # https://developer.hashicorp.com/consul/docs/agent/config/cli-flags
  command = var.command

  # https://developer.hashicorp.com/consul/docs/install/ports
  ports = [
    {
      # DNS: The DNS server (TCP and UDP)
      internal = "8600"
    },
    {
      # DNS: The DNS server (TCP and UDP)
      internal = "8600"
      protocol = "udp"
    },
    {
      # HTTP: The HTTP API (TCP Only)
      internal = "8500"
    },
    {
      # HTTPS: The HTTPs API
      internal = "8501"
    },
    {
      # gRPC: The gRPC API
      internal = "8502"
    },
    {
      # gRPC TLS: The gRPC API with TLS connections
      internal = "8503"
    },
    {
      # LAN Serf: The Serf LAN port (TCP and UDP)
      internal = "8301"
    },
    {
      # Wan Serf: The Serf WAN port (TCP and UDP)
      internal = "8302"
    },
    {
      # server: Server RPC address (TCP Only)
      internal = "8300"
    },
    {
      # server: Server RPC address (TCP Only)
      internal = "8300"
    },
  ]

  volumes = [
    {
      host_path      = local.data_dir
      container_path = "/consul/data"
    }
  ]
}

output "hostname" {
  value = module.docker.hostname
}
