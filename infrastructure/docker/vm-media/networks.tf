resource "docker_network" "traefik_intern" {
  name = "traefik_intern"
}

resource "docker_network" "lan" {
  name = "lan"
}