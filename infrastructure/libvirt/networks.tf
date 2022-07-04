locals {
  routed_subnet = "192.168.100.0/24"
}

resource "libvirt_network" "routed_network" {
  name = "routed_network"

  autostart = true

  mode = "route"
  domain = "routed.local"
  addresses = [local.routed_subnet]

  dns {
    enabled = true
  }

  dhcp {
    enabled = true
  }
}