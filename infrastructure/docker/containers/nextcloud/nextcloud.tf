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

resource "docker_container" "nextcloud" {
  name  = "nextcloud-app"
  image = docker_image.nextcloud.latest
  restart = "always"

  env = [
    # MySQL Configuration
    "MYSQL_DATABASE=nextcloud",
    "MYSQL_USER=nextcloud",
    "MYSQL_PASSWORD=${random_password.mariadb_nextcloud_password.result}",
    "MYSQL_HOST=${docker_container.mariadb.name}",

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
  // TODO Configure volumes properly

  # TODO Setup Reverse Proxy properly (See Warnings in Nextcloud Admin interface)

  volumes {
    container_path = "/var/www/html"
    host_path = "/opt/containers/nextcloud/app"
  }

  volumes {
    container_path = "/var/www/html/data"
    host_path = "/opt/containers/nextcloud/data"
  }

  depends_on = [
    docker_container.mariadb,
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