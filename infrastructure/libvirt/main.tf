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

   block_devices = [
      "/dev/pve-ssd/nextcloud", # vdc
      "/dev/backup1/nextcloud" # vdd
   ]

   mac = "52:54:00:6E:3A:C2"

   mounts = [
      [ "/dev/vdc", "/mnt/nextcloud" ],
      ["/dev/vdd", "/mnt/backups/nextcloud"]
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
      "/dev/disk1/media", # vdc
      "/dev/disk2/media", # vdd
      "/dev/disk3/media", # vde
      "/dev/parity1/media", #vdf
      "/dev/backup1/media" # vdg
   ]

   files = [
      { path="/opt/snapraid-runner/snapraid-runner.conf", content = templatefile("${path.module}/files/snapraid-runner.conf", {
         from_mail = var.media_mail
         to_mail = var.admin_mail
      })},
      { path="/opt/snapraid-runner/snapraid-media.conf", content = file("${path.module}/files/snapraid-media.conf")},
      { path="/etc/cron.d/snapraid", content = templatefile("${path.module}/files/snapraid-cron.conf", {
         healthcheck = healthchecksio_check.snapraid_media.ping_url
      })},
   ]


   mounts = [
      ["/dev/vdc", "/mnt/disks/media1"],
      ["/dev/vdd", "/mnt/disks/media2"],
      ["/dev/vde", "/mnt/disks/media3"],
      ["/dev/vdf", "/mnt/parity1/media"],
      ["/mnt/disks/media*", "/mnt/media", "fuse.mergerfs", "defaults,allow_other,use_ino,cache.files=off,moveonenospc=true,category.create=epmfs,func.mkdir=mspmfs,dropcacheonclose=true,minfreespace=60G,fsname=mergerfs", "0", "0"],
      ["/dev/vdg", "/mnt/backups"],
   ]

   pci_devices = [
      {
         name = "hostdev0",
         host = {
            bus = "0x05",
            slot= "0x00"
         }
         guest = {
            bus = "0x00",
            slot="0x0d"
         }
      },
      {
         name = "hostdev1",
         host = {
            bus = "0x06",
            slot = "0x00"
         }
         guest = {
            bus = "0x00",
            slot="0x0e"
         }
      }
   ]


   usb_devices = [
      {
         name = "hostdev2"
         host = {
            bus = "1"
            device = "2"
         }
         guest = {
            bus = "0"
            port = "1"
         }
         vendor = "0x0bda"
         product = "0x0165"
      }
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