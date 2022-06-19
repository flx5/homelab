locals {
  password = "passw0rd"
}

source "qemu" "media" {
  iso_url           = "output/docker/docker.qcow2"
  iso_checksum      = "file:output/docker/packer_docker_sha1.checksum"
  disk_image        = true
  headless          = true

  output_directory  = "output/media"
  shutdown_command  = "sudo shutdown -P now"
  disk_size         = "20G"
  format            = "qcow2"

  ssh_username      = "packer"
  ssh_password      = local.password
  ssh_timeout       = "2m"
  vm_name           = "media.qcow2"
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
  sources = ["source.qemu.media"]

  provisioner "file" {
    source = "${path.root}/firmware/dvb-demod-si2168-d60-01.fw"
    destination = "/tmp/dvb-demod-si2168-d60-01.fw"
  }

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y mergerfs snapraid",

      # We need the normal kernel, not the cloud one because the tv card driver cx23885.ko is not included in cloud drivers
      "apt-get install -y linux-image-amd64",
      "apt-get remove -y linux-image-*-cloud-amd64 linux-image-cloud-amd64",
      # Reboot to make sure that the kernel change worked
      "reboot",

      # Check that the running kernel is not a cloud image (-v negates the match)
      "uname -r | grep -vq cloud",
      # Try to load the tv card module,
      "modprobe cx23885",

      # Install firmware
      #
      # The script mentioned here does not support this card yet, but everything else is the same.
      # https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-5500#Firmware
      "cp /tmp/dvb-demod-si2168-d60-01.fw /lib/firmware/",
      "depmod -a"
    ]

    expect_disconnect = true

    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]

    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }

  # Reset Cloud Init
  provisioner "shell" {
    inline = [
      "sudo cloud-init clean"
    ]
  }
}
