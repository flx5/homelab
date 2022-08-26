output "hostnames" {
  value = merge(local.hostnames, module.addons.hostnames)
}

output "backup" {
  value = {
    tvheadend = module.tvheadend.backup
  }
}