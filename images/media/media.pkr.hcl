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

  provisioner "shell" {
    inline = [
      "set -e",
      "apt-get update",
      "apt-get install -y mergerfs snapraid",

      # We need the normal kernel, not the cloud one because the tv card driver cx23885.ko is not included in cloud drivers
      "apt-get install -y linux-image-amd64",
      "apt-get remove -y linux-image-*-cloud-amd64 linux-image-cloud-amd64",

      # Configure the module
      # https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/issues/51
      "echo 'options cx23885 dma_reset_workaround=2' > /etc/modprobe.d/Hauppauge-WinTV-QuadHD.conf"
    ]

    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]

    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }

  # Reboot to make sure that the kernel change worked
  provisioner "shell" {
    inline = [
      "sudo reboot"
    ]
    expect_disconnect = true
  }

  # Verify the installed kernel supports the required module
  provisioner "shell" {
    inline = [
      "set -e",
      # Check that the running kernel is not a cloud image (-v negates the match)
      "uname -r | grep -vq cloud",
      # Try to load the tv card module,
      "sudo modprobe cx23885"
    ]
  }

  provisioner "file" {
    source = "${path.root}/firmware/dvb-demod-si2168-d60-01.fw"
    destination = "/tmp/dvb-demod-si2168-d60-01.fw"
  }

  # Install firmware
  #
  # The script mentioned here does not support this card yet, but everything else is the same.
  # https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-5500#Firmware
  provisioner "shell" {
    inline = [
      "set -e",
      "sudo cp /tmp/dvb-demod-si2168-d60-01.fw /lib/firmware/",
      "sudo depmod -a"
    ]
  }

  # Install snapraid runner
  provisioner "shell" {
    inline = [
      "set -e",
      "sudo mkdir /opt/snapraid-runner/",
      "wget -O- https://raw.githubusercontent.com/Chronial/snapraid-runner/v0.5/snapraid-runner.py | sudo tee /opt/snapraid-runner/snapraid-runner.py >/dev/null",
    ]
  }

  # Reset Cloud Init
  provisioner "shell" {
    inline = [
      "sudo cloud-init clean"
    ]
  }
}
