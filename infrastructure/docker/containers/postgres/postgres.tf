resource "docker_image" "postgres" {
  name = "postgres:16.4-alpine"
}

resource "docker_container" "postgres" {
  name  = var.name
  image = docker_image.postgres.image_id
  restart = "unless-stopped"

  # Backend Network
  networks_advanced {
    name = var.network
  }

  command = var.command

  healthcheck {
    test = [ "CMD-SHELL", "pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}" ]
    start_period = "20s"
    interval = "30s"
    retries = 5
    timeout = "5s"
  }

  # Allow clean shutdown
  destroy_grace_seconds = 120

  volumes {
    container_path = "/var/lib/postgresql/data"
    host_path = "/opt/containers/${var.name}/database"
  }

  env = [
    "POSTGRES_DB=${var.database}",
    "POSTGRES_USER=${var.username}",
    "POSTGRES_PASSWORD=${var.password}",
  ]
}