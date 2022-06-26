resource "docker_image" "duplicati" {
  name = "duplicati-custom"

  build {
    path = path.module
    tag  = ["duplicati-custom"]
    label = {
      trigger_dockerfile_hash = filemd5("${path.module}/Dockerfile")
    }
  }
}

# Start a container
resource "docker_container" "duplicati" {
  name  = "duplicati-app"
  image = docker_image.duplicati.latest

  restart = "always"

  volumes {
    container_path = "/data"
    host_path = "/opt/containers/duplicati/config"
  }

  dynamic "volumes" {
    for_each = var.volumes
    content {
      container_path = volumes.value.container_path
      host_path = volumes.value.host_path
      read_only = volumes.value.read_only
    }
  }

  networks_advanced {
    name = var.traefik_network
  }

  networks_advanced {
    name = var.mail_network
  }

  dynamic "networks_advanced" {
    for_each = var.networks
    content {
      name = networks_advanced.value
    }
  }

  dynamic "upload" {
    for_each = var.scripts
    content {
      file = "/opt/scripts/${upload.key}.sh"
      content = upload.value
      executable = true
    }
  }
}
