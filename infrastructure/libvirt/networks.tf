resource "libvirt_network" "routed_network" {
  name = "routed_network"

  autostart = true

  mode = "route"
  domain = "routed.local"
  addresses = ["10.17.2.0/24"]

  dns {
    enabled = true
  }

  dhcp {
    enabled = true
  }
}