/*resource "null_resource" "backup-scripts" {
  # TODO Add triggers

  connection {
    type     = "ssh"
    user     = var.docker_user
    host = var.docker_host
  }

  provisioner "file" {
    content = templatefile("${path.module}/files/nextcloud-pre.sh", {
       app_container = docker_container.nextcloud.id
       db_container = module.database.container.id
       user = local.db_user
       password = var.db_password
       database = local.database
       dump_folder = "/opt/containers/backup/nextcloud"
    })
    destination = "/tmp/nextcloud_pre.sh"
  }
  
  provisioner "file" {
    content = templatefile("${path.module}/files/nextcloud-post.sh", {
       app_container = docker_container.nextcloud.id
     })
    destination = "/tmp/nextcloud_post.sh"
  }
}*/
