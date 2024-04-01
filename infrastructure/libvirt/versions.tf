terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    healthchecksio = {
      source = "kristofferahl/healthchecksio"
      version = "2.0.0"
    }
    sops = {
      source = "carlpett/sops"
      version = "1.0.0"
    }
  }
}

