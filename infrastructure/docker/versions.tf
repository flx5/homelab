terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    ssh = {
      source = "loafoe/ssh"
      version = "2.6.0"
    }

    sops = {
      source = "carlpett/sops"
      version = "1.0.0"
    }

    healthchecksio = {
      source = "kristofferahl/healthchecksio"
      version = "1.10.1"
    }
  }
}
