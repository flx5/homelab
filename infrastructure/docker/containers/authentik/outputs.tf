output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.authentik.name
    fqdn = var.fqdn
    cert_resolver = var.cert_resolver
  })
}

output "backup" {
  value = {

    pre = templatefile("${path.module}/files/backup.sh", {
      app_container = docker_container.authentik.id
      db_container = module.database.container.id
      user = local.db_user
      password = var.db_password
      database = local.database
      dump_folder = "${var.dump_folder}/authentik"
    })

    post = "docker container start '${docker_container.authentik.id}'"

    vm_folders = [ for folder in [ var.data_dir ] : folder.path if folder.backup ]
  }
}