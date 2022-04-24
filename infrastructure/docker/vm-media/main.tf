module "tvheadend" {
   source = "../containers/tvheadend"
   traefik_network = docker_network.traefik_intern.name
}


module "jellyfin" {
   source = "../containers/jellyfin"
   traefik_network = docker_network.traefik_intern.name
}

module "addons" {
   source = "git::ssh://git@github.com/flx5/homelab-addons.git//media"
   traefik_network = docker_network.traefik_intern.name
}

module "traefik" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.lan.name
   configurations = merge({
      jellyfin = module.jellyfin.traefik_config,
      tvheadend = module.tvheadend.traefik_config
   }, module.addons.traefik_config)
   additional_entrypoints = {}
}