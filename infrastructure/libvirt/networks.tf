resource "libvirt_network" "admin_network" {
  name = "admin_network"

  autostart = true

  mode = "none"
  domain = "admin.local"
  addresses = ["10.17.2.0/24"]

  dns {
    enabled = false
  }

  dhcp {
    enabled = false
  }
}

resource "libvirt_network" "internet_network" {
  name = "internet_network"

  autostart = true

  mode = "bridge"
  bridge = "br-eno1"
}