resource "libvirt_volume" "mydisk" {
  name           = "docker_${var.name}"

  base_volume_id = var.base_disk
  pool = var.pool_name
}

resource "libvirt_volume" "data" {
  name           = "docker_${var.name}_data.qcow2"
  size = var.data_size == 0 ? 10 * pow(1024, 3) : var.data_size

  pool = var.data_pool_name

  lifecycle {
    prevent_destroy = true
  }
}
