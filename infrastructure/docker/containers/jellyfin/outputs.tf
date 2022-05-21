output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.jellyfin.name
    fqdn = var.fqdn
  })
}