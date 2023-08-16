resource "libvirt_volume" "mydisk" {
  name           = "kubernetes_${var.name}"

  base_volume_id = var.base_disk
  pool = var.pool_name
}