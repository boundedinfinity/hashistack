
variable "path" {
  type = string
}

locals {
  file = "${var.path}/.terraformignore"
}

resource "local_file" "path" {
  content  = ""
  filename = local.file
}
