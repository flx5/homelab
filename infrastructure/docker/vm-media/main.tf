locals {
   hostnames = {
      jellyfin = "media.${var.base_domain}"
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
}

# TODO Backup
module "jellyfin" {
   source = "../containers/jellyfin"
   traefik_network = docker_network.traefik_intern.name
   fqdn = local.hostnames.jellyfin
}

# TODO Backup configurations
module "addons" {
   source = "git::ssh://git@github.com/flx5/homelab-addons.git//media"
   traefik_network = docker_network.traefik_intern.name
   base_domain = var.base_domain
   
   sftp_host = var.sftp_host
   sftp_user = var.sftp_user
   sftp_password = var.sftp_password
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
}
