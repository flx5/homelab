# Start a container
resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.latest
  restart = "always"

  networks_advanced {
      name = var.network_name
  }
}

resource "docker_image" "nginx" {
  name = "nginx"
}
