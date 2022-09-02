resource "docker_image" "traefik" {
  name = "traefik:v2.8"
}

module "error_host" {
  source = "../nginx"
  traefik_network = var.internal_network_name

  files = [
    { filename = "index.html", content = "You have reached /dev/null" }
  ]

  fqdn = "error.local"
}

resource "docker_container" "traefik" {
  name  = var.hostname
  image = docker_image.traefik.latest
  restart = "unless-stopped"

  env = [
    "CF_API_EMAIL=${var.cloudflare_email}",
    "CF_API_KEY=${var.cloudflare_api_key}",
    "LEGO_CA_CERTIFICATES=/etc/traefik/ca_cert.pem"
  ]

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
      homelab_ca = var.homelab_ca
      homelab_ca_cert = var.homelab_ca_cert
    })
  }

  upload {
    file = "/etc/traefik/hosts/common.yml"
    content = templatefile("${path.module}/common.yml", {
      error = module.error_host.name
    })
  }

  upload {
    file = "/etc/traefik/ca_cert.pem"
    content = var.homelab_ca_cert
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
