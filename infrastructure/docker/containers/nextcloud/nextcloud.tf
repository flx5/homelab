resource "docker_image" "nextcloud" {
  name = "nextcloud:21.0.9"
}

resource "docker_image" "mariadb" {
  name = "mariadb:10.7.3"
}

resource "random_password" "mariadb_root_password" {
  length           = 16
}

resource "random_password" "mariadb_nextcloud_password" {
  length           = 16
}

resource "docker_container" "mariadb" {
  name  = "nextcloud-db"
  image = docker_image.mariadb.latest
  restart = "always"

  command = ["--transaction-isolation=READ-COMMITTED", "--log-bin=ROW", "-innodb_read_only_compressed=OFF"]

  networks_advanced {
    name = var.network_name
  }

  volumes {
    container_path = "/var/lib/mysql"
    host_path = "/opt/containers/nextcloud/database"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mariadb_root_password.result}",
    "MYSQL_DATABASE=nextcloud",
    "MYSQL_USER=nextcloud",
    "MYSQL_PASSWORD=${random_password.mariadb_nextcloud_password.result}",
  ]
}

resource "docker_container" "nextcloud" {
  name  = "nextcloud-app"
  image = docker_image.nextcloud.latest
  restart = "always"

  env = [
    "MYSQL_DATABASE=nextcloud",
    "MYSQL_USER=nextcloud",
    "MYSQL_PASSWORD=${random_password.mariadb_nextcloud_password.result}",
    "MYSQL_HOST=${docker_container.mariadb.hostname}"
  ]

  depends_on = [
    docker_container.mariadb
  ]

  networks_advanced {
    name = var.network_name
  }
}