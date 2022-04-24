module "images" {
   source = "./images"
   pool_name = libvirt_pool.stage_prod.name
}

module "vm_web" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = libvirt_network.internet_network.domain
   name = "web"
   network = libvirt_network.internet_network.id
   pool_name = libvirt_pool.stage_prod.name
   ssh_id = var.ssh_id
}

module "vm_media" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = libvirt_network.internet_network.domain
   name = "media"
   network = libvirt_network.internet_network.id
   pool_name = libvirt_pool.stage_prod.name
   ssh_id = var.ssh_id
}