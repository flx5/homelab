terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
      version = "1.0.4"
    }
    sops = {
      source = "carlpett/sops"
    }
  }
}
