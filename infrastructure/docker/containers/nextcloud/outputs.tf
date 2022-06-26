output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.nextcloud.name
    fqdn = var.fqdn
  })
}

output "backend_network" {
  value = docker_network.nextcloud_backend
}

output "backup_pre" {
  value = templatefile("${path.module}/files/nextcloud-pre.sh", {
    app = docker_container.nextcloud.hostname
    db_host = module.database.container.name
    user = local.db_user
    password = var.db_password
    database = local.database
  })
}

output "backup_post" {
  value = templatefile("${path.module}/files/nextcloud-post.sh", {
    app = docker_container.nextcloud.hostname
  })
}