output "admin_adresses" {
  description = "The administration ips of the instance(s)"
  value = [ for instance in libvirt_domain.docker.*.network_interface : { for iface in instance : iface.network_name => iface.addresses.0 if length(iface.addresses) > 0 } ]
}