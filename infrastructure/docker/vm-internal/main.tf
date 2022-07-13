locals {
   traefik_name = "traefik"
   hostnames = {
      nextcloud = "cloud.internal.${var.base_domain}"
      duplicati = "duplicati.internal.${var.base_domain}"
   }
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
   traefik_network_name = docker_network.traefik_intern.name
}

module "nextcloud" {
   source = "../containers/nextcloud"

   smtp_host = module.mail.server
   smtp_port = module.mail.port
   traefik_host = local.traefik_name
   traefik_network = docker_network.traefik_intern.name
   mail_network = docker_network.mail.name
   db_password = var.nextcloud_db_password
   db_root_password = var.nextcloud_db_root_password

   fqdn = local.hostnames.nextcloud

   # TODO Fix
   data_dir = "/opt/nextcloud"
}

module "addons" {
   source = "git::ssh://git@github.com/flx5/homelab-addons.git//internal"
   traefik_network = docker_network.traefik_intern.name
   base_domain = var.base_domain
}

resource "random_password" "salt" {
  length = 8
}

resource "htpasswd_password" "hash" {
  password = var.auth_password
  salt     = random_password.salt.result
}

module "traefik" {
   source = "../containers/traefik"

   hostname = local.traefik_name
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.lan.name
   configurations = merge({
      nextcloud = module.nextcloud.traefik_config
      internalAuth: templatefile("internal-auth.yml", {
         users = {
            "${var.auth_username}" = htpasswd_password.hash.bcrypt
         }
      })
   }, module.addons.traefik_config)
   additional_entrypoints = {}

   cloudflare_email = var.cloudflare_email
   cloudflare_api_key = var.cloudflare_api_key
   acme_email = var.acme_email
}
