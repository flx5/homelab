resource "libvirt_pool" "stage_prod" {
  name = "stage_prod"
  type = "dir"
  path = "/tmp/terraform-provider-libvirt-pool-debian"
}