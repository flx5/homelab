resource "docker_image" "duplicati" {
  name = "duplicati/duplicati"
}

# Start a container
resource "docker_container" "duplicati" {
  name  = "duplicati-app"
  image = docker_image.duplicati.latest
  restart = "always"

  volumes {
    container_path = "/data"
    host_path = "/opt/containers/duplicati/config"
  }

  networks_advanced {
    name = var.traefik_network
  }

  networks_advanced {
    name = var.mail_network
  }
}
