terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
      version = "1.2.1"
    }
    sops = {
      source = "carlpett/sops"
    }
  }
}
