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
   data_pool_name = libvirt_pool.data.name

   ssh_id = var.ssh_id

   spice_address = var.host

   block_devices = [ "/dev/pve-ssd/nextcloud" ]

   mac = "52:54:00:6E:3A:C2"

   mounts = [
      [ "/dev/vdc", "/mnt/nextcloud" ]
   ]
}

module "vm_media" {
   source = "./apps/docker"

   base_disk = module.images.media
   domain = local.domain
   name = "media"
   bridge = local.bridge
   pool_name = libvirt_pool.stage_prod.name
   data_pool_name = libvirt_pool.data.name
   ssh_id = var.ssh_id

   spice_address = var.host

   mac = "52:54:00:2E:ED:B0"

   block_devices = [
      "/dev/disk1/media",
      "/dev/disk2/media",
      "/dev/disk3/media",
      "/dev/parity1/media",
   ]

   # TODO Make sure snapraid runs in regular intervals

   mounts = [
      ["/dev/vdc", "/mnt/disks/media1"],
      ["/dev/vdd", "/mnt/disks/media2"],
      ["/dev/vde", "/mnt/disks/media3"],
      ["/dev/vdf", "/mnt/parity1/media"],
      ["/mnt/disks/media*", "/mnt/media", "fuse.mergerfs", "defaults,allow_other,use_ino,cache.files=off,moveonenospc=true,category.create=epmfs,func.mkdir=mspmfs,dropcacheonclose=true,minfreespace=60G,fsname=mergerfs", "0", "0"]
   ]
}

module "vm_internal" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = local.domain
   name = "internal"
   bridge = local.bridge
   pool_name = libvirt_pool.stage_prod.name
   data_pool_name = libvirt_pool.data.name
   ssh_id = var.ssh_id

   spice_address = var.host

   mac = "52:54:00:42:7E:88"
}