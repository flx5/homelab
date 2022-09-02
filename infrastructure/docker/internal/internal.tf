locals {
  traefik_name = "traefik"
  hostnames = {
    nextcloud = "cloud.internal.${var.base_domain}"
  }

  smtp_host = var.smtp_host
  smtp_port = 25
}

data "sops_file" "secrets" {
  source_file = "${path.module}/secrets.yml"
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

  # TODO Fix and backup
  data_dir = { path = "/opt/nextcloud", backup = false }
  app_folder = { path = "/opt/containers/nextcloud/app", backup = true }

  dump_folder = var.dump_folder

  cert_resolver = "homelab"
}

module "addons" {
  source = "git::ssh://git@github.com/flx5/homelab-addons.git//internal?ref=ea353c11"
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
  homelab_ca = var.homelab_ca
  homelab_ca_cert = var.homelab_ca_cert
}