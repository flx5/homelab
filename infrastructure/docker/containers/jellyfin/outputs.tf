output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.jellyfin.name
    fqdn = var.fqdn
  })
}

output "backup" {
  value = {
    pre =  "docker container stop ${docker_container.jellyfin.id}"
    post = "docker container start ${docker_container.jellyfin.id}"

    vm_folders = [ local.config_path ]
  }
}