locals {
   docker_ip = cidrhost(libvirt_network.internet_network.addresses.0, 10)
}

module "debian" {
   source = "./modules/vm/debian"
   ssh_id = var.ssh_id
   docker_ip = local.docker_ip
   networks = {
      admin_network = libvirt_network.admin_network
      internet_network = libvirt_network.internet_network
   }
}

/*
TODO Docker Provider tries to ping the docker server before anything else can run...
     Thus containers and VMs have to be provisioned separately

module "docker" {
   source = "./modules/container"

   docker_host = "ssh://core@${local.docker_ip}:22"
   test = module.debian.docker_addresses
}*/