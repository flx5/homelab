resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "k3s_server_commoninit.iso"
  user_data = templatefile("${path.module}/cloud_init.yaml", {
    ssh_id = var.ssh_id
  })
  pool = var.pool_name
}