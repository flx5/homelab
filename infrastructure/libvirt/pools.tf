resource "libvirt_pool" "stage_prod" {
  name = "stage_prod"
  type = "dir"
  path = "/mnt/vm/libvirt"
}


resource "libvirt_pool" "data" {
  name = "data"
  type = "dir"
  path = "/mnt/vm/data"

  lifecycle {
    prevent_destroy = true
  }
}