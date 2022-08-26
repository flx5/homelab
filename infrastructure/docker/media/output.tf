output "hostnames" {
  value = merge(local.hostnames, module.addons.hostnames)
}