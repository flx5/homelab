locals {
  port = 25
}

resource "docker_image" "mailhog" {
  name = "mailhog/mailhog"
}

resource "docker_container" "mailhog" {
  name  = "mailhog"
  image = docker_image.mailhog.latest
  restart = "always"

  env = [
    "MH_SMTP_BIND_ADDR=0.0.0.0:${local.port}",
    "MH_UI_WEB_PATH=mail"
  ]

  networks_advanced {
    name = var.network_name
  }
}

output "server" {
  value = docker_container.mailhog.name
}

output "port" {
  value = local.port
}