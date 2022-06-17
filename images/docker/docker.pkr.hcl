locals {
  password = "passw0rd"
}

source "qemu" "docker" {
  iso_url           = "https://cloud.debian.org/images/cloud/bullseye/20220310-944/debian-11-genericcloud-amd64-20220310-944.qcow2"
  iso_checksum      = "sha512:607c5b7fa5fed5fffa30839d137de66ed89466870ce03018466c5e5b330d655a49cc4bb4b7d9651af84379575cceb8ec79c0943c7f9b626f8b1d977267fa0ad7"
  disk_image        = true
  headless          = true

  output_directory  = "output/docker"
  shutdown_command  = "sudo shutdown -P now"
  disk_size         = "20G"
  format            = "qcow2"

  ssh_username      = "packer"
  ssh_password      = local.password
  ssh_timeout       = "2m"
  vm_name           = "docker.qcow2"
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
  sources = ["source.qemu.docker"]

  provisioner "shell" {
    script = "${path.root}/install.sh"
  }

  # Reset Cloud Init
  provisioner "shell" {
    inline = [
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-guest-agent"
    ]
  }

  # Reset Cloud Init
  provisioner "shell" {
    inline = [
      "sudo cloud-init clean"
    ]
  }
}
