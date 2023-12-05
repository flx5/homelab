resource "docker_image" "redis" {
  name = "redis:7.2"
}

resource "random_password" "redis_password" {
  length           = 16
  special = false
}

resource "docker_container" "redis" {
  name  = var.name
  image = docker_image.redis.image_id
  restart = "unless-stopped"

  command = ["redis-server", "--requirepass", random_password.redis_password.result]

  healthcheck {
    test = ["CMD-SHELL", "redis-cli ping | grep PONG"]
    start_period = "20s"
    interval = "30s"
    retries = 5
    timeout = "3s"
  }

  # Backend Network
  networks_advanced {
    name = var.network
  }
}
