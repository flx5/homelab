locals {
  hostname = "k8s-${var.name}"
  addresses = coalesce([
    for iface in libvirt_domain.kubernetes.network_interface[*].addresses :
        iface.0 if length(iface) > 0
    ]...)
}