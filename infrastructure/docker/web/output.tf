output "hostnames" {
  value = local.hostnames
}

output "internal_hostnames" {
  value = local.internal_hostnames
}

output "backup" {
  value = {
    nextcloud = module.nextcloud.backup
    gitea = module.gitea.backup
    calibre = module.calibre.backup
    step-ca = module.step-ca.backup
  }
}

output "root_ca" {
  value = module.step-ca.root_ca
}
