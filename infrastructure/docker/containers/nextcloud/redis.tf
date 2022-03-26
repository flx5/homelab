resource "docker_image" "redis" {
  name = "redis:6.2"
}

resource "random_password" "redis_password" {
  length           = 16
}

resource "docker_container" "redis" {
  name  = "nextcloud-redis"
  image = docker_image.redis.latest
  restart = "always"

  command = ["redis-server", "--requirepass", random_password.redis_password.result]

  networks_advanced {
    name = var.network_name
  }
}