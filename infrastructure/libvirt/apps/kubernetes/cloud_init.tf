resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "kubernetes_${var.name}_commoninit.iso"
  user_data = templatefile("${path.module}/cloud_init.yaml", {
    ssh_id = var.ssh_id
    hostname = local.hostname
  })
  pool = var.pool_name
}