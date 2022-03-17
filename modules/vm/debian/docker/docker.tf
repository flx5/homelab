resource "libvirt_domain" "docker" {
  name   = "docker_${var.name}"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.mydisk.id
  }

  network_interface {
    network_id     = var.networks.internet_network.id
    wait_for_lease = true
    addresses = [ var.docker_ip ]
    hostname = local.fqdn
  }
}