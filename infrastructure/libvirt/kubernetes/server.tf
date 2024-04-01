resource "libvirt_volume" "server" {
  count          = var.server_count
  name           = "k3s-server-${count.index}"
  size = 10 * pow(1024, 3)
  pool = var.pool_name
}

resource "libvirt_domain" "kubernetes" {
  count          = var.server_count
  name   = "k3s-server-${count.index}"
  memory = "1024"
  vcpu   = 1

  cpu {
    mode = "host-passthrough"
  }

  cmdline     = []

  autostart = true

  qemu_agent = false

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.server[count.index].id
  }

  disk {
    #url = "https://github.com/kairos-io/kairos/releases/download/v2.4.3/kairos-debian-bookworm-standard-amd64-generic-v2.4.3-k3sv1.27.6+k3s1.iso"
    file = "/mnt/vm/libvirt/kairos-debian-bookworm-standard-amd64-generic-v2.4.3-k3sv1.27.6+k3s1.iso"
  }

  network_interface {
    network_id     = var.network
    wait_for_lease = false
  }

  boot_device {
    dev = [ "hd", "cdrom"]
  }
}
