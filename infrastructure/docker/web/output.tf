output "hostnames" {
  value = local.hostnames
}

output "backup" {
  value = {
    nextcloud = module.nextcloud.backup
    gitea = module.gitea.backup
    calibre = module.calibre.backup
  }
}