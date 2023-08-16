resource "libvirt_volume" "kubernetes" {
  name   = "kubernetes"
  source = "https://cloud.debian.org/images/cloud/bullseye/20230802-1460/debian-11-genericcloud-amd64-20230802-1460.qcow2"
  pool = var.pool_name
}

output "kubernetes" {
  value = libvirt_volume.kubernetes.id
}