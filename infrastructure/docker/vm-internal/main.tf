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


module "duplicati" {
   source = "../containers/duplicati"

   traefik_network = docker_network.traefik_intern.name
   mail_network = docker_network.mail.name
   fqdn = local.hostnames.duplicati

   volumes = [
      { container_path = "/scratch/", host_path = "/mnt/backups/scratch/", read_only = false },
      { container_path = "/data_src/nextcloud", host_path = "/mnt/stash/nextcloud", read_only = true },
      { container_path = "/data_src/stash", host_path = "/mnt/stash/stash", read_only = true },
      { container_path = "/data_backup/", host_path = "/mnt/backups/", read_only = false },
   ]

   scripts = {
      nextcloud_pre = module.nextcloud.backup_pre
      nextcloud_post = module.nextcloud.backup_post

      # TODO Scripts from addon module
   }
}

module "traefik" {
   source = "../containers/traefik"

   hostname = local.traefik_name
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.lan.name
   configurations = merge({
      nextcloud = module.nextcloud.traefik_config
      duplicati = module.duplicati.traefik_config
   }, module.addons.traefik_config)
   additional_entrypoints = {}
}