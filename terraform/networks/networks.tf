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

variable "management_name" {
    type = string
    default = "hashistack_management"
}

variable "application_name" {
    type = string
    default = "hashistack_application"
}

resource "docker_network" "management" {
    name = var.management_name
}

resource "docker_network" "application" {
    name = var.application_name
}

output "management" {
    value = docker_network.management
}

output "application" {
    value = docker_network.application
}