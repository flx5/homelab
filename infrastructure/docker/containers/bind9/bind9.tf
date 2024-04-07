resource "random_password" "password" {
  length           = 64
  special          = true
}

resource "docker_image" "bind9" {
  name = "internetsystemsconsortium/bind9:9.19"
}

resource "docker_container" "bind9" {
  name  = var.hostname
  image = docker_image.bind9.image_id
  restart = "unless-stopped"

  ports {
    internal = "53"
    external = "53"
    protocol = "tcp"
  }

  ports {
    internal = "53"
    external = "53"
    protocol = "udp"

    # Workaround for issue https://forums.docker.com/t/dns-issues-with-local-resolver-and-containers-on-the-same-host/102319/4
    ip = var.server_ip
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
      public_domain = var.public_domain
    })
  }

  # Store Journal for dynamic entries
  volumes {
    container_path = "/var/lib/bind"
    host_path = "/opt/containers/bind9/zones/"
  }
  
  volumes {
    container_path = "/var/log"
    host_path = "/opt/containers/bind9/logs/"
  }

  upload {
    file = "/var/lib/bind/db.home"
    content = templatefile("${path.module}/db.home", {
      server_ip = var.server_ip
    })
  }
  
  upload {
    file = "/var/lib/bind/db.public"
    content = templatefile("${path.module}/db.public", {
      server_ip = var.server_ip
      public_domain = var.public_domain
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
