locals {
  config_path = "/opt/containers/jellyfin/config"
}

# Start a container
resource "docker_container" "jellyfin" {
  name  = "jellyfin"
  image = docker_image.jellyfin.image_id
  restart = "unless-stopped"

  env = [
    "JELLYFIN_PublishedServerUrl=${var.fqdn}"
  ]

  networks_advanced {
      name = var.traefik_network
  }

  volumes {
    container_path = "/config"
    host_path = local.config_path
  }

  volumes {
    container_path = "/cache"
    host_path = "/opt/containers/jellyfin/cache"
  }

  volumes {
    container_path = "/Audio"
    host_path = "/mnt/media/Audio"
  }

  volumes {
    container_path = "/Videos"
    host_path = "/mnt/media/Videos"
  }
}

resource "docker_image" "jellyfin" {
  name = "jellyfin/jellyfin:10.8.4"
}
