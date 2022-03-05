output "ip-addresses" {
  value = {
    for key in var.machines :
    "${var.cluster_name}-${key}" => libvirt_domain.machine[key].network_interface.0.addresses.*
  }
  # or instead of outputs, use dig CLUSTERNAME-VMNAME @192.168.122.1
}

output "ip-addr" {
  value = libvirt_domain.machine["mynode"].network_interface.0.addresses.0
  
}
