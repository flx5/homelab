resource "docker_image" "mariadb" {
  name = "mariadb:11.5.2"
}

resource "docker_container" "mariadb" {
  name  = var.name
  image = docker_image.mariadb.image_id
  restart = "unless-stopped"

  # Backend Network
  networks_advanced {
    name = var.network
  }

  command = var.command

  # Allow clean shutdown
  destroy_grace_seconds = 120

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