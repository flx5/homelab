locals {
  database = "nextcloud"
  db_user = "nextcloud"
}

resource "docker_image" "nextcloud" {
  name = "nextcloud-full"
  build {
    path = path.module
    tag  = ["nextcloud-full"]
  }
}

resource "docker_network" "nextcloud_backend" {
  name = "nextcloud_backend"
}

module "database" {
  source = "../mariadb"
  database = local.database
  name =  "nextcloud-db"
  network = docker_network.nextcloud_backend.name
  username = local.db_user
  password = var.db_password
  command = ["--transaction-isolation=READ-COMMITTED", "--log-bin=ROW", "--innodb_read_only_compressed=OFF"]
}

resource "docker_container" "nextcloud" {
  name  = "nextcloud-app"
  image = docker_image.nextcloud.latest
  restart = "always"

  env = [
    # MySQL Configuration
    "MYSQL_DATABASE=${local.database}",
    "MYSQL_USER=${local.db_user}",
    "MYSQL_PASSWORD=${var.db_password}",
    "MYSQL_HOST=${module.database.container.name}",

    # Redis Configuration
    "REDIS_HOST=${docker_container.redis.name}",
    "REDIS_HOST_PASSWORD=${random_password.redis_password.result}",

    # Mail Configuration
    "SMTP_HOST=${var.smtp_host}",
    "SMTP_PORT=${var.smtp_port}",
    "SMTP_AUTHTYPE=PLAIN",
    "MAIL_FROM_ADDRESS=nextcloud",
    "MAIL_DOMAIN=nextcloud.local",
    # TODO Configure SMTP (From) correctly

    # Proxy Configuration
    "TRUSTED_PROXIES=${var.traefik_host}"
  ]

  volumes {
    container_path = "/var/www/html"
    host_path = "/opt/containers/nextcloud/app"
  }

  volumes {
    container_path = "/var/www/html/data"
    host_path = "/opt/containers/nextcloud/data"
  }

  depends_on = [
    module.database.container,
    docker_container.redis
  ]

  # Backend Network
  networks_advanced {
    name = docker_network.nextcloud_backend.name
  }

  # Traefik Network
  networks_advanced {
    name = var.traefik_network
  }
}