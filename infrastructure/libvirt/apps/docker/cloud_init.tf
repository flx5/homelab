resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "docker_${var.name}_commoninit.iso"
  user_data = templatefile("${path.module}/cloud_init.cfg", {
    ssh_id = var.ssh_id
    hostname = local.hostname
    fqdn = local.fqdn
    mounts = var.mounts
    packages = var.packages
  })
  network_config = templatefile("${path.module}/network_config.cfg", {})
  pool = var.pool_name
}