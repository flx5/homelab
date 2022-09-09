output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.gitea.name,
    fqdn = var.fqdn
    cert_resolver = var.cert_resolver
  })
}

output "backup" {
  value = {
    pre = templatefile("${path.module}/files/gitea-pre.sh", {
      app_container = docker_container.gitea.id
      db_container  = module.database.container.id
      user          = local.db_user
      password      = var.db_password
      database      = local.database
      dump_folder   = "${var.dump_folder}/gitea"
    })

    post = templatefile("${path.module}/files/gitea-post.sh", {
      app_container = docker_container.gitea.id
    })

    vm_folders = [ for folder in [ var.data_path ] : folder.path if folder.backup ]
  }
}
