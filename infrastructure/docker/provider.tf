# Terraform seems to enforce default provider
provider "docker" {
  host     = "ssh://${var.docker_web_user}@${var.docker_web_host}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

provider "docker" {
  alias = "web"

  host     = "ssh://${var.docker_web_user}@${var.docker_web_host}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

provider "docker" {
  alias = "media"

  host     = "ssh://${var.docker_media_user}@${var.docker_media_host}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

provider "docker" {
  alias = "internal"

  host     = "ssh://${var.docker_internal_user}@${var.docker_internal_host}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}