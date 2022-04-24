# Start a container
resource "docker_container" "jellyfin" {
  name  = "jellyfin"
  image = docker_image.jellyfin.latest
  restart = "always"

  env = [
    "JELLYFIN_PublishedServerUrl=jellyfin.local"
  ]

  networks_advanced {
      name = var.traefik_network
  }

  volumes {
    container_path = "/config"
    host_path = "/opt/containers/jellyfin/config"
  }

  volumes {
    container_path = "/cache"
    host_path = "/opt/containers/jellyfin/cache"
  }

  # TODO Add media folders as bind mounts
}

resource "docker_image" "jellyfin" {
  name = "jellyfin/jellyfin"
}
