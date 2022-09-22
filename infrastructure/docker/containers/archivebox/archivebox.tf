resource "docker_image" "archivebox" {
  name = "archivebox/archivebox:0.6.3"
}

resource "docker_container" "archivebox" {
  name  = "archivebox-app"
  image = docker_image.archivebox.image_id
  restart = "unless-stopped"

  command = [ "server", "--quick-init", "0.0.0.0:8000"]

  # TODO Sonic for full text search as documented in docker compose file

  volumes {
    container_path = "/data"
    host_path = var.data_path.path
  }

  networks_advanced {
    name = var.traefik_network
  }
}
