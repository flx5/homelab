locals {
  password = "passw0rd"
}


source "qemu" "hypervisor" {
  iso_url           = "https://cloud.debian.org/images/cloud/bullseye/20220310-944/debian-11-generic-amd64-20220310-944.qcow2"
  iso_checksum      = "sha512:e4d7a17e007d42a65d29144b0bb333398cd0726b8fc50d9a9d7c25e2d8583d769519ac177bac1d26d2dcfd84921f54254b8990ea42012b6da6c1658599b8811d"
  disk_image        = true
  #headless          = true

  output_directory  = "output/hypervisor"
  shutdown_command  = "sudo shutdown -P now"
  disk_size         = "20G"
  format            = "qcow2"

  ssh_username      = "packer"
  ssh_password      = local.password
  ssh_timeout       = "2m"
  vm_name           = "hypervisor.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"

  cd_content = {
    "meta-data" = templatefile("cloud-init/meta-data.yml", {
    })
    "user-data" = templatefile("cloud-init/user-data.yml", {
      password = bcrypt(local.password)
    })
  }
  cd_label = "cidata"

}

build {
  sources = ["source.qemu.hypervisor"]

  # TODO Install Cockpit
  # TODO Install libvirt
  # TODO Install mdadm
  # TODO Install borg and configure backups
  # TODO Install hardware specific drivers
  # TODO Configure disk spin down
  # TODO Configure disk monitoring and mail sending

  # TODO Make sure fsteutates module is installed https://forum.siduction.org/index.php?topic=7773.0

  # TODO Convert to UEFI with https://github.com/juan-vg/maas/wiki/Create-a-Debian-9-%28Stretch%29-image-that-works-with-UEFI-secure-booting

  # Reset Cloud Init
  provisioner "shell" {
    inline = [
      "sudo cloud-init clean"
    ]
  }
}
