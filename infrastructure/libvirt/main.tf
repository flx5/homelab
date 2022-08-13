module "images" {
   source = "./images"
   pool_name = libvirt_pool.stage_prod.name
}

data "sops_file" "nas_key" {
   source_file = "../../keys/nas_id_rsa.yml"
}

module "vm_web" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = libvirt_network.routed_network.domain
   name = "web"

   network = libvirt_network.routed_network.id
   address = cidrhost(local.routed_subnet, 10)

   pool_name = libvirt_pool.stage_prod.name
   data_pool_name = libvirt_pool.data.name

   ssh_id = var.ssh_id
   ssh_backup_id = data.sops_file.nas_key.data["public"]

   spice_address = var.host

   block_devices = [
      "/dev/pve-ssd/nextcloud", # vdc
      "/dev/backup1/nextcloud" # vdd
   ]

   mounts = [
      [ "/dev/vdc", "/mnt/nextcloud" ],
      ["/dev/vdd", "/mnt/backups"]
   ]

   # Add this to the bridged network because the Fritz!Box doesn't support creating a port forwarding rule to a routed network.
   bridge = "br-eno1"
   bridge_mac = "52:54:00:6E:3A:C2"
}

module "vm_media" {
   source = "./apps/docker"

   base_disk = module.images.media
   domain = libvirt_network.routed_network.domain
   name = "media"

   network = libvirt_network.routed_network.id
   address = cidrhost(local.routed_subnet, 11)

   pool_name = libvirt_pool.stage_prod.name
   data_pool_name = libvirt_pool.data.name
   ssh_id = var.ssh_id
   ssh_backup_id = data.sops_file.nas_key.data["public"]

   spice_address = var.host

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
         guest = {
            port = "1"
         }
         vendor = "0x0bda"
         product = "0x0165"
      }
   ]
   
   # Card reader fails with usb3 so use a usb2 bus...
   use_ich9_controller = true

   data_size = 30 * pow(1024, 3)
}

module "vm_internal" {
   source = "./apps/docker"

   base_disk = module.images.docker
   domain = libvirt_network.routed_network.domain
   name = "internal"

   network = libvirt_network.routed_network.id
   address = cidrhost(local.routed_subnet, 12)

   pool_name = libvirt_pool.stage_prod.name
   data_pool_name = libvirt_pool.data.name
   ssh_id = var.ssh_id
   ssh_backup_id = data.sops_file.nas_key.data["public"]

   spice_address = var.host

   block_devices = [
      "/dev/disk1/stash", # vdc
      "/dev/disk2/stash", # vdd
      "/dev/disk3/stash", # vde
      "/dev/parity1/stash", #vdf
      "/dev/backup1/stash" # vdg
   ]

   # TODO Configure snapraid

   mounts = [
      ["UUID=5f7fd7df-475b-41cc-94cf-402429efbaf2", "/mnt/disks/stash1"],
      ["UUID=5e16c451-d8a6-4c53-90b8-62b0328dbe86", "/mnt/disks/stash2"],
      ["UUID=dc217d83-0a36-47a8-a899-78479a8a1992", "/mnt/disks/stash3"],
      ["UUID=f0b5fab4-ebb8-4cca-8bb9-f179fd0a409c", "/mnt/parity1/stash"],
      ["/mnt/disks/stash*", "/mnt/stash", "fuse.mergerfs", "defaults,allow_other,use_ino,cache.files=off,moveonenospc=true,category.create=epmfs,func.mkdir=mspmfs,dropcacheonclose=true,minfreespace=60G,fsname=mergerfs", "0", "0"],
      ["UUID=a7a973fe-5211-4e81-81a8-87a503bf572c", "/mnt/backups"],
   ]

   packages = ["mergerfs", "snapraid"]
}
