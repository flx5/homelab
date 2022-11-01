locals {
  database = "gitea"
  db_user = "gitea"
}

resource "docker_image" "gitea" {
  name = "gitea/gitea:1.17.3"
}

resource "docker_network" "gitea_backend" {
  name = "gitea_backend"
}

module "database" {
  source = "../mariadb"
  database = local.database
  name =  "gitea-db"
  network = docker_network.gitea_backend.name
  username = local.db_user
  password = var.db_password
  root_password = var.db_root_password
}

# Start a container
resource "docker_container" "gitea" {
  name  = "gitea-app"
  image = docker_image.gitea.image_id
  restart = "unless-stopped"

  env = [
    "USER_UID=1000",
    "USER_GID=1000",

    # Site information
    "GITEA__DEFAULT__APP_NAME=Gitea",

    # Database configuration
    "GITEA__database__DB_TYPE=mysql",
    "GITEA__database__HOST=${module.database.container.name}:3306",
    "GITEA__database__NAME=${local.database}",
    "GITEA__database__USER=${local.db_user}",
    "GITEA__database__PASSWD=${var.db_password}",

    # Mail configuration
    "GITEA__mailer__ENABLED=true",
    "GITEA__mailer__FROM=gitea@${var.fqdn}",
    "GITEA__mailer__MAILER_TYPE=smtp",
    "GITEA__mailer__HOST=${var.smtp_host}:${var.smtp_port}",
    # TODO Enable TLS
    "GITEA__mailer__IS_TLS_ENABLED=false",

    # Server configuration
    "GITEA__server__PROTOCOL=http",
    "GITEA__server__DOMAIN=${var.fqdn}",
    "GITEA__server__ROOT_URL=https://${var.fqdn}/",
    "GITEA__server__SSH_DOMAIN=${var.fqdn}",
    "GITEA__server__SSH_PORT=2222",

    # I don't really need gravatars...
    "GITEA__server__OFFLINE_MODE=true",

    "GITEA__openid__ENABLE_OPENID_SIGNIN=false",
    "GITEA__service__DISABLE_REGISTRATION=true",

    "GITEA__service.explore__REQUIRE_SIGNIN_VIEW=true",
  ]

  volumes {
    container_path = "/data"
    host_path = var.data_path.path
  }

  networks_advanced {
    name = var.traefik_network
  }

  networks_advanced {
    name = docker_network.gitea_backend.name
  }

  depends_on = [
    module.database.container
  ]
}
