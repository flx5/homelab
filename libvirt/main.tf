locals {
   docker_ip = cidrhost(libvirt_network.internet_network.addresses.0, 10)
}

module "debian_bullseye" {
   source = "./os/debian/bullseye"

   name = "default"
   pool_name = libvirt_pool.stage_prod.name
}

module "docker" {
   source = "./apps/docker"

   base_disk = module.debian_bullseye.base_image
   domain = libvirt_network.internet_network.domain
   name = "default"
   network = libvirt_network.internet_network.id
   pool_name = libvirt_pool.stage_prod.name
   ssh_id = var.ssh_id
}

/*
TODO Docker Provider tries to ping the docker server before anything else can run...
     Thus containers and VMs have to be provisioned separately

module "docker" {
   source = "./modules/container"

   docker_host = "ssh://core@${local.docker_ip}:22"
   test = module.debian.docker_addresses
}*/