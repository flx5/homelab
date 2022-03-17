resource "libvirt_network" "admin_network" {
  name = "admin_network"

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

  mode = "nat"
  domain = "inet.local"

  addresses = ["10.17.3.0/24"]

  dns {
    enabled = true
  }

  dhcp {
    enabled = true
  }
}