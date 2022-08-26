output "hostnames" {
  value = merge(local.hostnames, module.addons.hostnames)
}

output "backup" {
  value = merge({
    nextcloud = module.nextcloud.backup
  }, module.addons.backup)
}