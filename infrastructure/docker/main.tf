locals {
  smtp_host = cidrhost("${var.docker_web_host}/24", 1)
  dump_folder = "/mnt/backup/source/dumps"
}

module "web" {
  source = "./web"
  providers = {
    docker = docker.web
  }

  smtp_host = local.smtp_host
  acme_email = var.acme_email
  base_domain = var.base_domain
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_email = var.cloudflare_email

  dump_folder = "${local.dump_folder}/vm-web"
}

module "media" {
  source = "./media"

  providers = {
    docker = docker.media
  }

  acme_email = var.acme_email
  base_domain = var.base_domain
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_email = var.cloudflare_email
  sftp_host = var.sftp_host
  sftp_password = var.sftp_password
  sftp_user = var.sftp_user
}

module "internal" {
  source = "./internal"

  providers = {
    docker = docker.internal
  }

  acme_email                 = var.acme_email
  auth_password              = var.internal_auth_password
  auth_username              = var.internal_auth_username
  base_domain                = var.base_domain
  cloudflare_api_key         = var.cloudflare_api_key
  cloudflare_email           = var.cloudflare_email
  smtp_host                  = local.smtp_host

  dump_folder = "${local.dump_folder}/vm-internal"
}
