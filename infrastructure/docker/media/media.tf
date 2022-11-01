locals {
   hostnames = {
      jellyfin  = "media.${var.base_domain}"
      tvheadend = "tv.media.${var.base_domain}"
   }
}

module "tvheadend" {
   source = "../containers/tvheadend"
   traefik_network = docker_network.traefik_intern.name
   fqdn = local.hostnames.tvheadend

   devices = [
      "/dev/dvb/adapter0",
      "/dev/dvb/adapter1",
      "/dev/dvb/adapter2",
      "/dev/dvb/adapter3",
   ]

   recordings_path = {
      path = "/opt/containers/tvheadend/recordings"
      backup = true
   }

   config_path = {
      path = "/opt/containers/tvheadend/config"
      backup = true
   }
}

module "jellyfin" {
   source = "../containers/jellyfin"
   traefik_network = docker_network.traefik_intern.name
   fqdn = local.hostnames.jellyfin
}

module "addons" {
   source = "git::ssh://git@github.com/flx5/homelab-addons.git//media?ref=8518208"
   traefik_network = docker_network.traefik_intern.name
   base_domain = var.base_domain
}


module "traefik" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.lan.name
   configurations = merge({
      jellyfin = module.jellyfin.traefik_config,
      tvheadend = module.tvheadend.traefik_config
   }, module.addons.traefik_config)

   additional_entrypoints = {
      tvheadend_htsp = 9982
   }

   cloudflare_email = var.cloudflare_email
   cloudflare_api_key = var.cloudflare_api_key
   acme_email = var.acme_email
   homelab_ca = var.homelab_ca
   homelab_ca_cert = var.homelab_ca_cert
}
