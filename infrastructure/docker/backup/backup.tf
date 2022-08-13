resource "ssh_resource" "backup" {
  host         = var.docker_host
  user         = var.docker_user
  agent        = true

  when         = "create"

  pre_commands = [
    "mkdir -p /home/docker/backup/scripts/"
  ]

  file {
    content     = templatefile("${path.module}/script_tpl.sh", {
      scripts = var.backup[*].backup_pre
    })
    destination = "/home/docker/backup/scripts/pre.sh"
    permissions = "0700"
  }

  file {
    content     = templatefile("${path.module}/script_tpl.sh", {
      scripts = var.backup[*].backup_post
    })
    destination = "/home/docker/backup/scripts/post.sh"
    permissions = "0700"
  }
}