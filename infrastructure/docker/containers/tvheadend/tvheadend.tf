# Start a container
resource "docker_container" "tvheadend" {
  name  = "tvheadend"
  image = docker_image.tvheadend.image_id
  restart = "unless-stopped"

  env = [

  ]

  networks_advanced {
      name = var.traefik_network
  }

  volumes {
    container_path = "/config"
    host_path = var.config_path.path
  }

  volumes {
    container_path = "/recordings"
    host_path = var.recordings_path.path
  }

  # TODO Add devices for dvb + vaapi
  dynamic "devices" {
    for_each = var.devices
    content {
      host_path = devices.value
      container_path = devices.value
      permissions    = "rwm"
    }
  }
}

resource "docker_image" "tvheadend" {
  name = "lscr.io/linuxserver/tvheadend:version-1c65e8b0"
}
