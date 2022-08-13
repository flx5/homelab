output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.nextcloud.name
    fqdn = var.fqdn
  })
}

output "backup_pre" {
  value = templatefile("${path.module}/files/nextcloud-pre.sh", {
    app_container = docker_container.nextcloud.id
    db_container = module.database.container.id
    user = local.db_user
    password = var.db_password
    database = local.database
    dump_folder = "/home/docker/backup/dumps/nextcloud"
  })
}

output "backup_post" {
  value = templatefile("${path.module}/files/nextcloud-post.sh", {
    app_container = docker_container.nextcloud.id
  })
}