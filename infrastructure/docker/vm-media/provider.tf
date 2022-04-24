provider "docker" {
  host     = "ssh://${var.docker_user}@${var.docker_host}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}
