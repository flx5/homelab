data "docker_registry_image" "calibre" {
  name = "lscr.io/linuxserver/calibre-web:0.6.19"
}

resource "docker_image" "calibre" {
  name          = data.docker_registry_image.calibre.name
  pull_triggers = [data.docker_registry_image.calibre.sha256_digest]
}

# Start a container
resource "docker_container" "calibre" {
  name  = "calibre-app"
  image = docker_image.calibre.latest
  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=Europe/Berlin",
    "DOCKER_MODS=linuxserver/mods:universal-calibre"
  ]

  volumes {
    container_path = "/config"
    host_path = var.config_path.path
  }

  volumes {
    container_path = "/books"
    host_path = var.books_path.path
  }

  networks_advanced {
    name = var.traefik_network
  }
}
