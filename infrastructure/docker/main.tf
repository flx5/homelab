# TODO Mail should be on own network because it might be unencrypted
module "mail" {
   source = "./containers/mail"
   network_name = docker_network.internal.name
}

module "nginx" {
   source = "./containers/nginx"
   network_name = docker_network.internal.name
}

module "nextcloud" {
   source = "./containers/nextcloud"
   network_name = docker_network.internal.name
   smtp_host = module.mail.server
   smtp_port = module.mail.port
}

module "traefik" {
   source = "./containers/traefik"
   internal_network_name = docker_network.internal.name
   wan_network_name = docker_network.wan.name
}
