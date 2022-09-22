resource "docker_image" "calibre" {
  name          = "lscr.io/linuxserver/calibre-web:0.6.19"
}

# Start a container
resource "docker_container" "calibre" {
  name  = "calibre-app"
  image = docker_image.calibre.image_id
  restart = "unless-stopped"

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

  healthcheck {
    test = ["CMD", "curl", "-f", "localhost:8083"]
    interval = "10m0s"

    # Allow for some time at start because the docker mod might need to be downloaded...
    start_period = "5m0s"
  }
}
