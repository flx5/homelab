resource "libvirt_domain" "kubernetes" {
  name   = local.hostname
  memory = var.memory
  vcpu   = 1

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

  network_interface {
    network_id     = var.network
    wait_for_lease = true
  }
}
