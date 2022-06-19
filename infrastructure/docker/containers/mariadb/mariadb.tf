resource "docker_image" "mariadb" {
  name = "mariadb:10.7.3"
}

resource "docker_container" "mariadb" {
  name  = var.name
  image = docker_image.mariadb.latest
  restart = "always"

  # Backend Network
  networks_advanced {
    name = var.network
  }

  command = var.command

  volumes {
    container_path = "/var/lib/mysql"
    host_path = "/opt/containers/${var.name}/database"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${var.root_password}",
    "MYSQL_DATABASE=${var.database}",
    "MYSQL_USER=${var.username}",
    "MYSQL_PASSWORD=${var.password}",
  ]
}