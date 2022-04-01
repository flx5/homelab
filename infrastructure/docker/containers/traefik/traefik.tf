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

  # Use file based configuration because of https://github.com/traefik/traefik/issues/4174
  upload {
    file = "/etc/traefik/traefik.yml"
    content = templatefile("${path.module}/traefik.yml", {})
  }

  upload {
    file = "/etc/traefik/hosts/fileconf.yml"
    content = templatefile("${path.module}/fileconf.yml", {})
  }
}

output "hostname" {
        value = docker_container.traefik.name
}