output "docker_addresses" {
  description = "The docker instance addresses on the admin interface"
  value = module.debian.docker_addresses
}