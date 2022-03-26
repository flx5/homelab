resource "libvirt_volume" "docker" {
  name   = "docker"
  source = abspath("${path.root}/../../images/output/docker/docker.qcow2")
  pool = var.pool_name
}

output "docker" {
  value = libvirt_volume.docker.id
}