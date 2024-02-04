locals {
   traefik_name_internal = "traefik_internal"
   traefik_name_public = "traefik_public"

   hostnames = {
      nextcloud = { url= "cloud.${var.base_domain}", public=true}
      calibre = { url="books.${var.base_domain}", public=true}
      gitea = { url= "git.${var.base_domain}", public=true }
      authentik = { url= "sso.${var.base_domain}", public=true }
   }

   internal_hostnames = {
      step-ca = "ca.home"
   }

   smtp_host = var.smtp_host
   smtp_port = 25

   # Data folders
   folders = {
      nextcloud = {
         app = "/opt/containers/nextcloud/app"
      }
      gitea = "/opt/containers/gitea/data"
   }
}

data "sops_file" "secrets" {
   source_file = "${path.module}/secrets.yml"
}

module "nextcloud" {
   source = "../containers/nextcloud"

   smtp_host = local.smtp_host
   smtp_port = local.smtp_port
   traefik_host = local.traefik_name_public
   traefik_network = docker_network.traefik_intern.name
   db_password = data.sops_file.secrets.data["nextcloud.db.user_password"]
   db_root_password = data.sops_file.secrets.data["nextcloud.db.root_password"]

   fqdn = local.hostnames.nextcloud.url

   data_dir = {
      path = "/mnt/nextcloud/data"
      # Backup via LVM
      backup = false
   }
   app_folder = {
      path = local.folders.nextcloud.app
      backup = true
   }

   dump_folder = var.dump_folder
}

module "gitea" {
   source = "../containers/gitea"

   fqdn = local.hostnames.gitea.url
   traefik_network = docker_network.traefik_intern.name
   smtp_host = local.smtp_host
   smtp_port = local.smtp_port
   db_password = data.sops_file.secrets.data["gitea.db.user_password"]
   db_root_password = data.sops_file.secrets.data["gitea.db.root_password"]

   data_path = {
      backup = true
      path = local.folders.gitea
   }

   dump_folder = var.dump_folder
}

module "calibre" {
   source = "../containers/calibre"

   traefik_network = docker_network.traefik_intern.name
   fqdn = local.hostnames.calibre.url

   books_path      = {
      path = "/opt/containers/calibre/books"
      backup = true
   }
   config_path     = {
      path = "/opt/containers/calibre/config"
      backup = true
   }
}

module "step-ca" {
   source = "../containers/step-ca"

   traefik_network = docker_network.traefik_intern.name

   config_dir   = {
      path = "/opt/containers/step-ca/config"
      backup = true
   }

   fqdn = local.internal_hostnames.step-ca
   ip_address = var.homelab_ca
}

module "traefik_intern" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.wan.name
   configurations = {
      step-ca = module.step-ca.traefik_config
   }

   hostname = local.traefik_name_internal

   acme_email = var.acme_email
   homelab_ca = var.homelab_ca
   homelab_ca_cert = module.step-ca.root_ca
}

module "traefik_public" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.wan.name
   configurations = {
      nextcloud = module.nextcloud.traefik_config,
      gitea   = module.gitea.traefik_config
      calibre = module.calibre.traefik_config
   }

   port_offset = 1
   hostname = local.traefik_name_public

   additional_entrypoints = {
      gitea_ssh = 2222
   }

   cloudflare_email = var.cloudflare_email
   cloudflare_api_key = var.cloudflare_api_key
   acme_email = var.acme_email
}
