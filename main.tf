module "flatcar" {
   source = "./modules/flatcar-ref"
   base_image = "${var.base_image}"
   cluster_name = "${var.cluster_name}"
   machines = "${var.machines}"
   virtual_memory = "${var.virtual_memory}"
   ssh_keys = "${var.ssh_keys}"
   
   # TODO Figure out where output from module lands
}
