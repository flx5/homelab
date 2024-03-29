resource "libvirt_domain" "docker" {
  name   = "docker_${var.name}"
  memory = var.memory
  vcpu   = var.vcpu

  cpu {
    mode = "host-passthrough"
  }

  cmdline     = []

  autostart = true

  qemu_agent = true

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.mydisk.id
  }

  disk {
    volume_id = libvirt_volume.data.id
  }

  dynamic "disk" {
    for_each = var.block_devices
    content {
      block_device = disk.value
    }
  }

  // TODO Change to management network
  graphics {
    type = "spice"
    listen_type = "address"
    listen_address = var.spice_address
  }

  network_interface {
    network_id     = var.network
    addresses = [ var.address ]
    hostname = local.hostname
    mac = var.mac
    wait_for_lease = true
  }

  # TODO This feels hacky and I should probably prefer a separate libvirt_domain definition for each variant
  dynamic "network_interface" {
    for_each = var.bridge == "" ? toset([]) : toset([1])
    content {
      bridge     = var.bridge
      wait_for_lease = true
      hostname = local.fqdn
      mac = var.bridge_mac
    }
  }

  xml {
    xslt = templatefile("xslt/add_hostdevs.xslt", {
      pci_devices = var.pci_devices
      usb_devices = var.usb_devices
      use_ich9_controller = var.use_ich9_controller
    })
  }
}
