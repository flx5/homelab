locals {
   traefik_name = "traefik"
   hostnames = {
      nextcloud = { url= "cloud.${var.base_domain}", public=true}
      calibre = { url="books.${var.base_domain}", public=false}
      gitea = { url= "git.${var.base_domain}", public=true }
   }
   
   smtp_host = cidrhost("${var.docker_host}/24", 1)
   smtp_port = 25
}

# TODO Backup
module "nextcloud" {
   source = "../containers/nextcloud"

   smtp_host = local.smtp_host
   smtp_port = local.smtp_port
   traefik_host = local.traefik_name
   traefik_network = docker_network.traefik_intern.name
   db_password = var.nextcloud_db_password
   db_root_password = var.nextcloud_db_root_password

   fqdn = local.hostnames.nextcloud.url

   data_dir = "/mnt/nextcloud/data"
}

# TODO Backup
module "gitea" {
   source = "../containers/gitea"

   fqdn = local.hostnames.gitea.url
   traefik_network = docker_network.traefik_intern.name
   smtp_host = local.smtp_host
   smtp_port = local.smtp_port
   db_password = var.gitea_db_password

   db_root_password = var.gitea_db_root_password
}

# TODO Backup
module "calibre" {
   source = "../containers/calibre"

   traefik_network = docker_network.traefik_intern.name
   fqdn = local.hostnames.calibre.url
}


module "traefik" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.wan.name
   configurations = {
      nextcloud = module.nextcloud.traefik_config,
      gitea   = module.gitea.traefik_config
      calibre = module.calibre.traefik_config
   }

   hostname = local.traefik_name

   additional_entrypoints = {
      gitea_ssh = 2222
   }

   acme_email = var.acme_email
}
