output "hostnames" {
  value = merge(local.hostnames, module.addons.hostnames)
}

output "backup" {
  value = merge({
    tvheadend = module.tvheadend.backup
    jellyfin = module.jellyfin.backup
  }, module.addons.backup)
}