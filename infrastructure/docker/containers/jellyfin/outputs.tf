output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {})
}