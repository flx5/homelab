resource "docker_image" "backblaze" {
  name = "tessypowder/backblaze-personal-wine"
}

# Start a container
resource "docker_container" "backblaze" {
  name  = "backblaze-app"
  image = docker_image.backblaze.latest
  restart = "always"

  env = [
    "APP_NICENESS=10",
    "USER_ID=1000",
    "GROUP_ID=1000",
    "TZ=Europe/Berlin"
  ]

  volumes {
    container_path = "/config"
    host_path = "/opt/containers/backblaze/config"
  }

  networks_advanced {
    name = var.traefik_network
  }
}
