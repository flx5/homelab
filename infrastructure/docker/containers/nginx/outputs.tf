output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.nginx.name
    fqdn = var.fqdn
  })
}