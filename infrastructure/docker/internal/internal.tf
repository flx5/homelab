locals {
  traefik_name = "traefik"
  hostnames = {
    nextcloud = "cloud.internal.${var.base_domain}"
    duplicati = "duplicati.internal.${var.base_domain}"
  }

  smtp_host = var.smtp_host
  smtp_port = 25
}

module "nextcloud" {
  source = "../containers/nextcloud"

  smtp_host = local.smtp_host
  smtp_port = local.smtp_port
  traefik_host = local.traefik_name
  traefik_network = docker_network.traefik_intern.name
  db_password = var.nextcloud_db_password
  db_root_password = var.nextcloud_db_root_password

  fqdn = local.hostnames.nextcloud

  # TODO Fix and backup
  data_dir = { path = "/opt/nextcloud", backup = false }
  app_folder = { path = "/opt/containers/nextcloud/app", backup = true }

  dump_folder = var.dump_folder
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
    internalAuth: templatefile("${path.module}/internal-auth.yml", {
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
