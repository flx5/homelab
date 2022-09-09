output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.archivebox.name,
    fqdn = var.fqdn
    cert_resolver = var.cert_resolver
  })
}

output "backup" {
  value = {
    pre =  "docker container stop ${docker_container.archivebox.id}"
    post = "docker container start ${docker_container.archivebox.id}"

    vm_folders = [ for folder in [ var.data_path ] : folder.path if folder.backup ]
  }
}
