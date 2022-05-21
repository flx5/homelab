output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.gitea.name,
    fqdn = var.fqdn
  })
}