locals {
  smtp_host = cidrhost("${var.docker_web_host}/24", 1)
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
  gitea_db_password = var.web_gitea_db_password
  gitea_db_root_password = var.web_gitea_db_root_password
  nextcloud_db_password = var.web_nextcloud_db_password
  nextcloud_db_root_password = var.web_nextcloud_db_root_password
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
  nextcloud_db_password      = var.internal_nextcloud_db_password
  nextcloud_db_root_password = var.internal_nextcloud_db_root_password
  smtp_host                  = local.smtp_host
}