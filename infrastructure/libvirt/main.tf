locals {
   domain = "fritz.box"
   bridge = "br-eno1"
}

module "images" {
   source = "./images"
   pool_name = libvirt_pool.stage_prod.name
}

module "vm_web" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = local.domain
   name = "web"
   bridge = local.bridge
   pool_name = libvirt_pool.stage_prod.name
   ssh_id = var.ssh_id
}

module "vm_media" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = local.domain
   name = "media"
   bridge = local.bridge
   pool_name = libvirt_pool.stage_prod.name
   ssh_id = var.ssh_id
}

module "vm_internal" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = local.domain
   name = "internal"
   bridge = local.bridge
   pool_name = libvirt_pool.stage_prod.name
   ssh_id = var.ssh_id
}