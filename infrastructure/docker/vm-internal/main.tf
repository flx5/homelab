locals {
   traefik_name = "traefik"
}

module "mail" {
   source = "../containers/mail"
   mail_network_name = docker_network.mail.name
   my_networks = join(",", [ for config in docker_network.mail.ipam_config : config.subnet ])
   mydomain = var.mail_mydomain
   relayhost = var.mail_relayhost
   relaypassword = var.mail_relaypassword
   relayport = var.mail_relayport
   relayuser = var.mail_relayuser
}

module "nextcloud" {
   source = "../containers/nextcloud"

   smtp_host = module.mail.server
   smtp_port = module.mail.port
   traefik_host = local.traefik_name
   traefik_network = docker_network.traefik_intern.name
   mail_network = docker_network.mail.name
   db_password = var.nextcloud_db_password
}

module "addons" {
   source = "git::ssh://git@github.com/flx5/homelab-addons.git//internal"
   traefik_network = docker_network.traefik_intern.name
}

module "traefik" {
   source = "../containers/traefik"

   hostname = local.traefik_name
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.lan.name
   configurations = merge({
      nextcloud = module.nextcloud.traefik_config
   }, module.addons.traefik_config)
   additional_entrypoints = {}
}