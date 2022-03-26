resource "docker_image" "nextcloud" {
  name = "nextcloud:21.0.9"
}

resource "docker_container" "nextcloud" {
  name  = "nextcloud-app"
  image = docker_image.nextcloud.latest
  restart = "always"

  env = [
    "MYSQL_DATABASE=nextcloud",
    "MYSQL_USER=nextcloud",
    "MYSQL_PASSWORD=${random_password.mariadb_nextcloud_password.result}",
    "MYSQL_HOST=${docker_container.mariadb.name}",

    "REDIS_HOST=${docker_container.redis.name}",
    "REDIS_HOST_PASSWORD=${random_password.redis_password.result}",

    "SMTP_HOST=${var.smtp_host}",
    "SMTP_PORT=${var.smtp_port}",
    "SMTP_AUTHTYPE=PLAIN",
    "MAIL_FROM_ADDRESS=nextcloud@nextcloud.local"
    # TODO Configure SMTP (From) correctly
  ]

  // TODO Configure volumes properly

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

  networks_advanced {
    name = var.network_name
  }
}