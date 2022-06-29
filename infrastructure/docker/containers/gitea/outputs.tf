output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.gitea.name,
    fqdn = var.fqdn
  })
}

output "backup_pre" {
  value = templatefile("${path.module}/files/gitea-pre.sh", {
    app_container = docker_container.gitea.id
    db_container = module.database.container.id
    user = local.db_user
    password = var.db_password
    database = local.database
  })
}

output "backup_post" {
  value = templatefile("${path.module}/files/gitea-post.sh", {
    app_container = docker_container.gitea.id
  })
}

output "host_data_path" {
  value = local.host_data_path
}