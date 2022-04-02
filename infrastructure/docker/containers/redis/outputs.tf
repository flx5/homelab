output "password" {
  value = random_password.redis_password.result
}

output "container" {
  value = docker_container.redis
}