terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    ssh = {
      source = "loafoe/ssh"
      version = "2.1.0"
    }
  }
}
