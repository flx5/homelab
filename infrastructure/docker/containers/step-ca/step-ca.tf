locals {
  container_name = "step-ca"
}

resource "random_password" "password" {
  length           = 64
  special          = false
}

resource "docker_image" "step-ca" {
  name = "smallstep/step-ca:0.22.1"
}

# To enable ACME the following command has to be run once:
# docker run -v /opt/containers/step-ca/config/:/home/step/ --rm -it smallstep/step-ca:0.22.0 step ca provisioner add acme --ca-url https://${var.ip_address}:9000 --type ACME

# The certificates can be obtained from https://ca.home/roots.pem
# Installing to trust stores https://smallstep.com/docs/step-cli/reference/certificate/install

resource "docker_container" "step-ca" {
  name  = local.container_name
  image = docker_image.step-ca.latest
  restart = "unless-stopped"

  dns = [ var.ip_address ]

  env = [
    "DOCKER_STEPCA_INIT_NAME=HomelabCA",
    "DOCKER_STEPCA_INIT_DNS_NAMES=localhost,${local.container_name},${var.fqdn},${var.ip_address}",
    "DOCKER_STEPCA_INIT_PASSWORD=${random_password.password.result}"
  ]

  ports {
    internal = 9000
    external = 9000
  }

  networks_advanced {
      name = var.traefik_network
  }

  volumes {
    container_path = "/home/step"
    host_path = var.config_dir.path
  }
}

data "tls_certificate" "ca_cert" {
  url = "https://${var.ip_address}:9000/roots.pem"
  verify_chain = false
}

