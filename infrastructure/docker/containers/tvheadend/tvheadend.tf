# Start a container
resource "docker_container" "tvheadend" {
  name  = "tvheadend"
  image = docker_image.tvheadend.latest
  restart = "always"

  env = [

  ]

  networks_advanced {
      name = var.traefik_network
  }

  volumes {
    container_path = "/config"
    host_path = "/opt/containers/tvheadend/config"
  }

  volumes {
    container_path = "/recordings"
    host_path = "/opt/containers/tvheadend/recordings"
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
  name = "lscr.io/linuxserver/tvheadend"
}
