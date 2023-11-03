# Start a container
resource "docker_container" "nginx" {
  name  = var.name
  image = docker_image.nginx.image_id
  restart = "unless-stopped"

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
  name = "nginx:1.25.3"
}
