locals {
  port = 25
}

resource "docker_image" "postfix" {
  name = "postfix"
  build {
    path = path.module
  }
}

# TODO internal TLS?

resource "docker_container" "postfix" {
  name  = "postfix"
  image = docker_image.postfix.latest
  restart = "unless-stopped"

  env = [
    "myhostname=postfix",
    "mydomain=${var.mydomain}",
    "relayhost=${var.relayhost}",
    "relayport=${var.relayport}",
    "relayuser=${var.relayuser}",
    "relaypassword=${var.relaypassword}",
    "mynetworks=${var.my_networks}",
    # TODO Configure proper nameserver
    "nameserver=1.1.1.1"
  ]

  networks_advanced {
    name = var.mail_network_name
  }

  networks_advanced {
    name = var.traefik_network_name
  }
}

output "server" {
  value = docker_container.postfix.name
}

output "port" {
  value = local.port
}