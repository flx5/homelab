resource "libvirt_pool" "stage_prod" {
  name = "stage_prod"
  type = "dir"
  path = "/home/felix/terraform-provider-libvirt-pool-debian"
}