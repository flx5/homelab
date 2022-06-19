locals {
   traefik_name = "traefik"
   hostnames = {
      nginx = "nginx.${var.base_domain}"
      nextcloud = "cloud.${var.base_domain}"
      calibre = "books.${var.base_domain}"
      backblaze = "backblaze.${var.base_domain}"
      gitea = "git.${var.base_domain}"
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
}


module "nginx" {
   source = "../containers/nginx"
   traefik_network = docker_network.traefik_intern.name

   fqdn = local.hostnames.nginx
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

   data_dir = "/mnt/nextcloud/data"
}

module "gitea" {
   source = "../containers/gitea"

   fqdn = local.hostnames.gitea
   traefik_network = docker_network.traefik_intern.name
   smtp_host = module.mail.server
   smtp_port = module.mail.port
   db_password = var.gitea_db_password
   mail_network = docker_network.mail.name

   db_root_password = var.gitea_db_root_password
}

module "calibre" {
   source = "../containers/calibre"

   traefik_network = docker_network.traefik_intern.name
   mail_network = docker_network.mail.name
   fqdn = local.hostnames.calibre
}

module "backblaze" {
   source = "../containers/backblaze"

   traefik_network = docker_network.traefik_intern.name
   fqdn = local.hostnames.backblaze
}

module "traefik" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.wan.name
   configurations = {
      nextcloud = module.nextcloud.traefik_config,
      nginx    = module.nginx.traefik_config,
      gitea   = module.gitea.traefik_config
      calibre = module.calibre.traefik_config
      backblaze = module.backblaze.traefik_config
   }

   hostname = local.traefik_name

   additional_entrypoints = {
      gitea_ssh = 2222
   }
}