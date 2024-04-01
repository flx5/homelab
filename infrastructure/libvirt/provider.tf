provider "libvirt" {
  uri = "qemu+ssh://felix@${var.host}/system"
}
