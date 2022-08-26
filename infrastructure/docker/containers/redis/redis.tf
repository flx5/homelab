resource "docker_image" "redis" {
  name = "redis:7.0"
}

resource "random_password" "redis_password" {
  length           = 16
}

resource "docker_container" "redis" {
  name  = var.name
  image = docker_image.redis.latest
  restart = "always"

  command = ["redis-server", "--requirepass", random_password.redis_password.result]

  # Backend Network
  networks_advanced {
    name = var.network
  }
}