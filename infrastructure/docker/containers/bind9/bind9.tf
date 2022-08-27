resource "random_password" "password" {
  length           = 64
  special          = true
}

resource "docker_image" "bind9" {
  name = "internetsystemsconsortium/bind9:9.18"
}

resource "docker_container" "bind9" {
  name  = var.hostname
  image = docker_image.bind9.latest
  restart = "always"

  ports {
    internal = "53"
    external = "53"
    protocol = "tcp"
  }

  ports {
    internal = "53"
    external = "53"
    protocol = "udp"
  }

  ports {
    internal = "953"
    external = "953"
    protocol = "udp"
    ip = "127.0.0.1"
  }


  upload {
    file = "/etc/bind/named.conf.options"
    content = templatefile("${path.module}/named.conf.options", {
    })
  }

  upload {
    file = "/etc/bind/named.conf.local"
    content = templatefile("${path.module}/named.conf.local", {
    })
  }

  upload {
    file = "/var/lib/bind/db.home"
    content = templatefile("${path.module}/db.home", {
      server_ip = var.server_ip
    })
  }

  upload {
    file = "/etc/bind/home.key"
    content = templatefile("${path.module}/tsig.key", {
      key_name = "home"
      secret = base64encode(random_password.password.result)
    })
  }
}