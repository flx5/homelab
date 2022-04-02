resource "docker_image" "mariadb" {
  name = "mariadb:10.7.3"
}

resource "random_password" "mariadb_root_password" {
  length           = 16
}

resource "random_password" "mariadb_gitea_password" {
  length           = 16
}

resource "docker_container" "mariadb" {
  name  = "gitea-db"
  image = docker_image.mariadb.latest
  restart = "always"

  # Backend Network
  networks_advanced {
    name = docker_network.gitea_backend.name
  }

  volumes {
    container_path = "/var/lib/mysql"
    host_path = "/opt/containers/gitea/database"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mariadb_root_password.result}",
    "MYSQL_DATABASE=gitea",
    "MYSQL_USER=gitea",
    "MYSQL_PASSWORD=${random_password.mariadb_gitea_password.result}",
  ]
}