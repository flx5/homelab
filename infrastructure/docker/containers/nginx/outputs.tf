output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.nginx.name
    fqdn = var.fqdn
    service_name = var.service_name
  })
}

output "service_name" {
  value = var.service_name
}

output "name" {
  value = docker_container.nginx.hostname
}