locals {
   traefik_name = "traefik"
   hostnames = {
      nextcloud = { url= "cloud.${var.base_domain}", public=true}
      calibre = { url="books.${var.base_domain}", public=false}
      gitea = { url= "git.${var.base_domain}", public=true }
      duplicati = { url = "duplicati.${var.base_domain}", public=false }
      mailer = { url = "internal-mailer.${var.base_domain}", public=false }
   }
}

module "mail" {
   source = "../containers/mail"
   mail_network_name = docker_network.mail.name
   my_networks = join(",", [ for config in setunion(docker_network.mail.ipam_config, docker_network.traefik_intern.ipam_config) : config.subnet ])
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

   fqdn = local.hostnames.nextcloud.url

   data_dir = "/mnt/nextcloud/data"
}

module "gitea" {
   source = "../containers/gitea"

   fqdn = local.hostnames.gitea.url
   traefik_network = docker_network.traefik_intern.name
   smtp_host = module.mail.server
   smtp_port = module.mail.port
   db_password = var.gitea_db_password
   mail_network = docker_network.mail.name

   db_root_password = var.gitea_db_root_password
}

# TODO Backup
module "calibre" {
   source = "../containers/calibre"

   traefik_network = docker_network.traefik_intern.name
   mail_network = docker_network.mail.name
   fqdn = local.hostnames.calibre.url
}

module "duplicati" {
   source = "../containers/duplicati"

   traefik_network = docker_network.traefik_intern.name
   mail_network = docker_network.mail.name
   fqdn = local.hostnames.duplicati.url

   volumes = [
      { container_path = "/scratch/", host_path = "/mnt/backups/scratch/", read_only = false },
      { container_path = "/data_src/nextcloud", host_path = "/mnt/nextcloud/data/", read_only = true },
      { container_path = "/data_backup/nextcloud", host_path = "/mnt/backups/nextcloud/", read_only = false },
      { container_path = "/data_backup/remote", host_path = "/mnt/backups/remote/", read_only = false },

      { container_path = "/data_src/gitea", host_path = module.gitea.host_data_path, read_only = true },
   ]

   scripts = {
      nextcloud_pre = module.nextcloud.backup_pre
      nextcloud_post = module.nextcloud.backup_post

      gitea_pre = module.gitea.backup_pre
      gitea_post = module.gitea.backup_post
   }
}

module "traefik" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.wan.name
   configurations = {
      nextcloud = module.nextcloud.traefik_config,
      gitea   = module.gitea.traefik_config
      calibre = module.calibre.traefik_config
      mail = module.mail.traefik_config
      duplicati = module.duplicati.traefik_config
   }

   hostname = local.traefik_name

   additional_entrypoints = {
      gitea_ssh = 2222
      mailer = 2525
   }

   acme_email = var.acme_email
}