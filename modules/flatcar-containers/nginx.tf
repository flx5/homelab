# Start a container
resource "docker_container" "nginx" {
  name  = "foo"
  image = docker_image.nginx.latest
  ports {
    internal = "80"
    external = "8080"
  }
}

# Find the latest Ubuntu precise image.
resource "docker_image" "nginx" {
  name = "nginx"
}
