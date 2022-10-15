locals {
  traefik_name = "traefik"
  hostnames = {
    nextcloud = "cloud.internal.${var.base_domain}"
    gitea = "git.internal.${var.base_domain}"
    archivebox = "archive.internal.${var.base_domain}"
  }

  smtp_host = var.smtp_host
  smtp_port = 25
}

data "sops_file" "secrets" {
  source_file = "${path.module}/secrets.yml"
}

module "gitea" {
   source = "../containers/gitea"

   fqdn = local.hostnames.gitea
   traefik_network = docker_network.traefik_intern.name
   smtp_host = local.smtp_host
   smtp_port = local.smtp_port
   db_password = data.sops_file.secrets.data["gitea.db.user_password"]
   db_root_password = data.sops_file.secrets.data["gitea.db.root_password"]

   data_path = {
      backup = true
      path = "/opt/containers/gitea"
   }

   dump_folder = var.dump_folder
   cert_resolver = "homelab"
}

module "nextcloud" {
  source = "../containers/nextcloud"

  smtp_host = local.smtp_host
  smtp_port = local.smtp_port
  traefik_host = local.traefik_name
  traefik_network = docker_network.traefik_intern.name
  db_password = data.sops_file.secrets.data["nextcloud.db.user_password"]
  db_root_password = data.sops_file.secrets.data["nextcloud.db.root_password"]

  fqdn = local.hostnames.nextcloud

  # Backup via LVM
  data_dir = { path = "/mnt/stash/nextcloud/", backup = false }
  app_folder = { path = "/opt/containers/nextcloud/app", backup = true }

  additional_volumes = [
    { name = "stash", path = "/mnt/stash/stash/data", backup = false }
  ]

  dump_folder = var.dump_folder

  cert_resolver = "homelab"
}

module "archivebox" {
  source = "../containers/archivebox"
  data_path = { path = "/opt/containers/archivebox", backup = true }
  traefik_network = docker_network.traefik_intern.name
  fqdn = local.hostnames.archivebox
  cert_resolver = "homelab"
}

module "addons" {
  source = "git::ssh://git@github.com/flx5/homelab-addons.git//internal?ref=65b429a3"
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
    gitea = module.gitea.traefik_config
    archivebox = module.archivebox.traefik_config
    internalAuth: templatefile("${path.module}/internal-auth.yml", {
      users = {
        "${var.auth_username}" = htpasswd_password.hash.bcrypt
      }
    })
  }, module.addons.traefik_config)
  additional_entrypoints = {
    gitea_ssh = 2222
  }

  cloudflare_email = var.cloudflare_email
  cloudflare_api_key = var.cloudflare_api_key
  acme_email = var.acme_email
  homelab_ca = var.homelab_ca
  homelab_ca_cert = var.homelab_ca_cert
}
