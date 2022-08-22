output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.nextcloud.name
    fqdn = var.fqdn
  })
}

output "backup" {
  value = {
    pre = templatefile("${path.module}/files/nextcloud-pre.sh", {
      app_container = docker_container.nextcloud.id
      db_container = module.database.container.id
      user = local.db_user
      password = var.db_password
      database = local.database
      dump_folder = "${var.dump_folder}/nextcloud"
    })

    post = templatefile("${path.module}/files/nextcloud-post.sh", {
      app_container = docker_container.nextcloud.id
    })

    vm_folders = [ for folder in [ var.app_folder, var.data_dir ] : folder.path if folder.backup ]
  }
}