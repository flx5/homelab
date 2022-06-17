resource "libvirt_pool" "stage_prod" {
  name = "stage_prod"
  type = "dir"
  path = "/mnt/vm/libvirt"
}