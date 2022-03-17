resource "libvirt_pool" "debian" {
  name = "debian"
  type = "dir"
  path = "/tmp/terraform-provider-libvirt-pool-debian"
}

resource "libvirt_volume" "debian" {
  name   = "leap"
  source = pathexpand("~/Downloads/debian-11-genericcloud-amd64-20220310-944.qcow2")
  pool = libvirt_pool.debian.name
}

module "docker" {
  source = "./docker"
  base_disk = libvirt_volume.debian.id
  name = "Docker"
  pool_name = libvirt_pool.debian.name
  ssh_id = var.ssh_id
  networks = var.networks
  docker_ip = var.docker_ip
}

module "test" {
  source = "./test"
  base_disk = libvirt_volume.debian.id
  name = "TestVM"
  networks = var.networks
  pool_name = libvirt_pool.debian.name
  ssh_id = var.ssh_id
}