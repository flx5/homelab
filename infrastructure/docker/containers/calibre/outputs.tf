output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.calibre.name
    fqdn = var.fqdn
  })
}


output "backup" {
  value = {
    pre =  "docker container stop ${docker_container.calibre.id}"
    post = "docker container start ${docker_container.calibre.id}"

    vm_folders = [ for folder in [ var.books_path, var.config_path ] : folder.path if folder.backup ]
  }
}