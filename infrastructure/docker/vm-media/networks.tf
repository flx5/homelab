resource "docker_network" "traefik_intern" {
  name = "traefik_intern"
  internal = true
}

resource "docker_network" "lan" {
  name = "lan"
}