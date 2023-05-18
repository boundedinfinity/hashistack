variable "root" {
  type = string
}


module "ensure_dir" {
  source = "../ensure_dir"
  path   = "${var.root}/.local"
}
