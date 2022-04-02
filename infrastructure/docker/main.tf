module "mail" {
   source = "./containers/mail"
   network_name = docker_network.traefik_intern.name
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
   db_password = var.nextcloud_db_password
}

module "gitea" {
   source = "./containers/gitea"

   traefik_network = docker_network.traefik_intern.name
   smtp_host = module.mail.server
   smtp_port = module.mail.port
   db_password = var.gitea_db_password
}

module "traefik" {
   source = "./containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.wan.name
   configurations = {
      nextcloud = module.nextcloud.traefik_config,
      nginx    = module.nginx.traefik_config,
      mail    = module.mail.traefik_config,
      gitea   = module.gitea.traefik_config
   }

   additional_entrypoints = {
      gitea_ssh = 2222
   }
}