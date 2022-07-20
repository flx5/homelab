source "qemu" "backup" {
  iso_url           = "https://cloud.debian.org/images/cloud/bullseye/20220310-944/debian-11-generic-amd64-20220310-944.qcow2"
  iso_checksum      = "sha512:e4d7a17e007d42a65d29144b0bb333398cd0726b8fc50d9a9d7c25e2d8583d769519ac177bac1d26d2dcfd84921f54254b8990ea42012b6da6c1658599b8811d"
  disk_image        = true
  headless          = false
  memory            = 2048
  cpus = 4

  output_directory  = "output/backup"
  shutdown_command  = "sudo shutdown -P now"
  disk_size         = "5G"
  format            = "raw"

  ssh_username      = var.username
  ssh_password      = var.password
  ssh_timeout       = "2m"
  vm_name           = "backup.img"
  net_device        = "virtio-net"
  disk_interface    = "virtio"

  cd_content = {
    "meta-data" = templatefile("cloud-init/meta-data.yml", {
    })
    "user-data" = templatefile("cloud-init/user-data.yml", {
      username = var.username
      password = bcrypt(var.password)
    })
    "network-config" = templatefile("cloud-init/network-config.yml", {
    })
  }
  cd_label = "cidata"

}

build {
  sources = ["source.qemu.backup"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      # Fix keyboard layout. The one specified in cloud-init does not seem to take effect
      "echo 'console-setup     console-setup/charmap47 select  UTF-8' | debconf-set-selections",
      "echo 'keyboard-configuration     keyboard-configuration/layout select German' | debconf-set-selections",
      "echo 'keyboard-configuration     keyboard-configuration/layoutcode string de' | debconf-set-selections",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y console-setup",
    ]

    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }

  # TODO Configure disk monitoring and mail sending

  provisioner "ansible" {
    playbook_file = "${path.root}/playbook.yml"
    user = var.username
  }
}
