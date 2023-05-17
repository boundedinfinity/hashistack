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

# set -gx TF_VAR_docker_sock ...
variable "docker_sock" {
  type    = string
  default = "unix:///var/run/docker.sock"
}

provider "docker" {
  host = var.docker_sock
}
