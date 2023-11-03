output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.nextcloud["app"].name
    fqdn = var.fqdn
    cert_resolver = var.cert_resolver
  })
}

output "backup" {
  value = {
    pre = templatefile("${path.module}/files/nextcloud-pre.sh", {
      app_container = docker_container.nextcloud["app"].id
      db_container = module.database.container.id
      user = local.db_user
      password = var.db_password
      database = local.database
      dump_folder = "${var.dump_folder}/nextcloud"
    })

    post = templatefile("${path.module}/files/nextcloud-post.sh", {
      app_container = docker_container.nextcloud["app"].id
    })

    vm_folders = [ for folder in concat([ var.app_folder, var.data_dir ], var.additional_volumes) : folder.path if folder.backup ]
  }
}