terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.20.2"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    ssh = {
      source = "loafoe/ssh"
      version = "2.1.0"
    }

    sops = {
      source = "carlpett/sops"
      version = "0.7.1"
    }

    healthchecksio = {
      source = "kristofferahl/healthchecksio"
      version = "1.9.0"
    }
  }
}
