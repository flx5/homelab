locals {
  hostname = "docker-${var.name}"
  fqdn = "${local.hostname}.${var.domain}"
}