resource "docker_image" "traefik" {
  name = "traefik:v2.6"
}

resource "docker_container" "traefik" {
  name  = var.hostname
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
    internal = "443"
    external = "443"
  }

  ports {
    internal = "8080"
    external = "8080"
  }

  dynamic "ports" {
    for_each = var.additional_entrypoints
    content {
      internal = ports.value
      external = ports.value
    }
  }

  # Use file based configuration because of https://github.com/traefik/traefik/issues/4174
  upload {
    file = "/etc/traefik/traefik.yml"
    content = templatefile("${path.module}/traefik.yml", {
      additional_entrypoints = var.additional_entrypoints,
      email = var.acme_email
    })
  }

  upload {
    file = "/etc/traefik/hosts/common.yml"
    content = templatefile("${path.module}/common.yml", {
      error = var.error_host
    })
  }

  dynamic "upload" {
    for_each = var.configurations
    content {
      file = "/etc/traefik/hosts/${upload.key}.yml"
      content = upload.value
    }
  }

  volumes {
    container_path = "/acme"
    host_path = "/opt/containers/traefik/acme"
  }
}