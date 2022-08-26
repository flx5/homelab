terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
    sops = {
      source = "carlpett/sops"
    }
  }
}
