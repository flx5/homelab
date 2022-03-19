output "docker_addresses" {
  description = "The docker instance addresses on the admin interface"
  value = module.docker.admin_adresses
}