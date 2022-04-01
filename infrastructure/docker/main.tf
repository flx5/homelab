# TODO Mail should be on own network because it might be unencrypted
module "mail" {
   source = "./containers/mail"
   network_name = docker_network.mail.name
}

module "traefik" {
   source = "./containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.wan.name
}

module "nginx" {
   source = "./containers/nginx"
   traefik_network = docker_network.traefik_intern.name
}

module "nextcloud" {
   source = "./containers/nextcloud"

   smtp_host = module.mail.server
   smtp_port = module.mail.port
   traefik_host = module.traefik.hostname
   traefik_network = docker_network.traefik_intern.name
}