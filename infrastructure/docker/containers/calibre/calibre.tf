resource "docker_image" "calibre" {
  name = "lscr.io/linuxserver/calibre-web"
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
    host_path = "/opt/containers/calibre/config"
  }

  volumes {
    container_path = "/books"
    host_path = "/opt/containers/calibre/books"
  }

  networks_advanced {
    name = var.traefik_network
  }
}
