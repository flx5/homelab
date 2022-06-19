provider "libvirt" {
  uri = "qemu+ssh://${var.host}/system"
}
