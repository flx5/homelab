output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.tvheadend.name
    fqdn = var.fqdn
  })
}

output "backup" {
  value = {
    pre =  "docker container stop ${docker_container.tvheadend.id}"
    post = "docker container start ${docker_container.tvheadend.id}"

    vm_folders = [ for folder in [ var.recordings_path, var.config_path ] : folder.path if folder.backup ]
  }
}