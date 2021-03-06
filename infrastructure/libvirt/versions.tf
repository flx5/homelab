terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.6.14"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    healthchecksio = {
      source = "kristofferahl/healthchecksio"
      version = "1.9.0"
    }
  }
}

