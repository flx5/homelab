locals {
   hostnames = {
      jellyfin = "media.${var.base_domain}"
      tvheadend = "tv.media.${var.base_domain}"
      duplicati = "duplicati.media.${var.base_domain}"
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
}

module "duplicati" {
   source = "../containers/duplicati"

   traefik_network = docker_network.traefik_intern.name

   fqdn = local.hostnames.duplicati

   volumes = [
      { container_path = "/data_src/media", host_path = "/mnt/media/", read_only = true },
      { container_path = "/data_backup/remote", host_path = "/mnt/backups/", read_only = false },
   ]

   # TODO This is the wrong network, but currently there is no mail network
   mail_network = docker_network.traefik_intern.name
}

module "traefik" {
   source = "../containers/traefik"
   internal_network_name = docker_network.traefik_intern.name
   wan_network_name = docker_network.lan.name
   configurations = merge({
      jellyfin = module.jellyfin.traefik_config,
      tvheadend = module.tvheadend.traefik_config
      duplicati = module.duplicati.traefik_config
   }, module.addons.traefik_config)
   additional_entrypoints = {
      tvheadend_htsp = 9982
   }
}