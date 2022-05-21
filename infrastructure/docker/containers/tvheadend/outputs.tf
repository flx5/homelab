output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.tvheadend.name
    fqdn = var.fqdn
  })
}