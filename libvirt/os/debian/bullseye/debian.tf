resource "libvirt_volume" "debian" {
  name   = "debian_bullseye_${var.name}"
  source = pathexpand("~/Downloads/debian-11-genericcloud-amd64-20220310-944.qcow2")
  pool = var.pool_name
}