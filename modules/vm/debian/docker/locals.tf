locals {
  hostname = "docker-${var.name}"
  fqdn = "${local.hostname}.${var.networks.internet_network.domain}"
}