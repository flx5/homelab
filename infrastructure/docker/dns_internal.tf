
module "bind9" {
  providers = {
    docker = docker.web
  }

  source = "./containers/bind9"
  server_ip = var.docker_web_host
}


provider "dns" {
  update {
    server        = var.docker_web_host
    key_name      = "home."
    key_algorithm = "hmac-sha256"
    key_secret    = module.bind9.tsig-secret
  }
}

resource "dns_a_record_set" "web" {
  zone = "home."
  name = "web"
  addresses = [
    var.docker_web_host
  ]
  ttl = 300
}

resource "dns_a_record_set" "media" {
  zone = "home."
  name = "media"
  addresses = [
    var.docker_media_host
  ]
  ttl = 300
}

resource "dns_a_record_set" "internal" {
  zone = "home."
  name = "internal"
  addresses = [
    var.docker_internal_host
  ]
  ttl = 300
}

