output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.nextcloud.name
    fqdn = var.fqdn
  })
}