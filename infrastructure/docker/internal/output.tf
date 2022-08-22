output "hostnames" {
  value = local.hostnames
}

output "backup" {
  value = {
    nextcloud = module.nextcloud.backup
  }
}