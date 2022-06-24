resource "libvirt_domain" "docker" {
  name   = "docker_${var.name}"
  memory = "2048"
  vcpu   = 1

  cpu {
    mode = "host-passthrough"
  }

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
    bridge     = var.bridge
    wait_for_lease = true
    hostname = local.fqdn
    mac = var.mac
  }
}