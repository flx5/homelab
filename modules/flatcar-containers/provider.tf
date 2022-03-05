terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

# TODO Should be output from other module
provider "docker" {
  host     = "ssh://core@192.168.122.56:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}
