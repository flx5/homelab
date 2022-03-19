resource "docker_image" "traefik" {
  name = "traefik:v2.6"
}

resource "docker_container" "traefik" {
  name  = "traefik"
  image = docker_image.traefik.latest
  restart = "always"

  networks_advanced {
    name = var.internal_network_name
  }

  networks_advanced {
    name = var.wan_network_name
  }

  ports {
    internal = "80"
    external = "80"
  }

  ports {
    internal = "8080"
    external = "8080"
  }

  upload {
    file = "/etc/traefik/traefik.yml"
    content = templatefile("${path.module}/traefik.yml", {})
  }

  # Use file based configuration because of https://github.com/traefik/traefik/issues/4174
  upload {
    file = "/etc/traefik/hosts/fileconf.yml"
    content = templatefile("${path.module}/fileconf.yml", {})
  }


}