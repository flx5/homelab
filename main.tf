output "flatcar_ip" {
  # TODO What about other (>= 1) values?
  value = values(module.flatcar.ip-addresses)[0][0]
}


module "flatcar" {
   source = "./modules/flatcar-ref"
   base_image = "${var.base_image}"
   cluster_name = "${var.cluster_name}"
   machines = "${var.machines}"
   virtual_memory = "${var.virtual_memory}"
   ssh_keys = "${var.ssh_keys}"
}

module "flatcar-docker" {
   source = "./modules/flatcar-containers"
   docker_ssh = values(module.flatcar.ip-addresses)[0][0]
}
