# Start a container
resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.latest
  restart = "always"

  dynamic "upload" {
    for_each = var.files
    content {
      file = "/usr/share/nginx/html/${upload.value.filename}"
      content = upload.value.content
    }
  }

  networks_advanced {
      name = var.traefik_network
  }
}

resource "docker_image" "nginx" {
  name = "nginx"
}
