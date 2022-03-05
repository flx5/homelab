# Run script to download and extract image file befor uploading to glance
resource "null_resource" "download-extract-image-flatcar" {
  provisioner "local-exec" {
    command = "${path.module}/download_flatcar.sh"
  }
}


resource "libvirt_volume" "flatcar" {
  name   = "flatcar.img"
  source = pathexpand("./flatcar_production_qemu_image.img")
  
  depends_on = [
    null_resource.download-extract-image-flatcar,
  ]
}

resource "libvirt_volume" "flatcar1" {
  name           = "flatcar1.qcow2"
  base_volume_id = libvirt_volume.flatcar.id
}

resource "libvirt_domain" "flatcar-linux1" {
  name = "flatcar-linux1"
  disk {
    volume_id = libvirt_volume.flatcar1.id
    scsi      = "true"
  }
  
  # TODO Add Ignition Config
  # https://www.flatcar.org/docs/latest/installing/vms/libvirt/
}
