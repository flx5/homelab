data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    "ssh_id" = var.ssh_id
    "hostname" = local.hostname
    "fqdn" = local.fqdn
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "docker_${var.name}_commoninit.iso"
  user_data = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool = var.pool_name
}