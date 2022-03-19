module "nginx" {
   source = "./containers/nginx"
   network_name = docker_network.internal.name
}

module "traefik" {
   source = "./containers/traefik"
   internal_network_name = docker_network.internal.name
   wan_network_name = docker_network.wan.name
}
