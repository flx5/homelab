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
    
    htpasswd = {
      source = "loafoe/htpasswd"
      version = "1.0.3"
    }
  }
}
