resource "docker_image" "gitea" {
  name = "gitea/gitea:1.16.5"
}

resource "docker_network" "gitea_backend" {
  name = "gitea_backend"
}

# Start a container
resource "docker_container" "gitea" {
  name  = "gitea"
  image = docker_image.gitea.latest
  restart = "always"

  env = [
    "USER_UID=1000",
    "USER_GID=1000",

    # Site information
    "GITEA__DEFAULT__APP_NAME=Gitea",

    # Database configuration
    "GITEA__database__DB_TYPE=mysql",
    "GITEA__database__HOST=${docker_container.mariadb.name}:3306",
    "GITEA__database__NAME=gitea",
    "GITEA__database__USER=gitea",
    "GITEA__database__PASSWD=${random_password.mariadb_gitea_password.result}",

    # Mail configuration
    "GITEA__mailer__ENABLED=true",
    "GITEA__mailer__FROM=gitea@gitea.local",
    "GITEA__mailer__MAILER_TYPE=smtp",
    "GITEA__mailer__HOST=${var.smtp_host}:${var.smtp_port}",
    "GITEA__mailer__IS_TLS_ENABLED=false",

    # Server configuration
    "GITEA__server__PROTOCOL=http",
    "GITEA__server__DOMAIN=gitea.local",
    "GITEA__server__ROOT_URL=http://gitea.local/",
    "GITEA__server__SSH_PORT=2222",
    # TODO Configure ssh
    # I don't really need gravatars...
    "GITEA__server__OFFLINE_MODE=true",

    "GITEA__openid__ENABLE_OPENID_SIGNIN=false",
    "GITEA__service__DISABLE_REGISTRATION=true",

    "GITEA__service.explore__REQUIRE_SIGNIN_VIEW=true",
  ]

  volumes {
    container_path = "/data"
    host_path = "/opt/containers/gitea/data"
  }

  networks_advanced {
    name = var.traefik_network
  }

  networks_advanced {
    name = docker_network.gitea_backend.name
  }

  depends_on = [
    docker_container.mariadb
  ]
}
