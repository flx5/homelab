resource "libvirt_volume" "media" {
  name   = "media"
  source = abspath("${path.root}/../../images/output/media/media.qcow2")
  pool = var.pool_name
}

output "media" {
  value = libvirt_volume.media.id
}