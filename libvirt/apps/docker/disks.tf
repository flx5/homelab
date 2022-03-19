resource "libvirt_volume" "mydisk" {
  name           = "docker_${var.name}"

  base_volume_id = var.base_disk
  pool = var.pool_name
}