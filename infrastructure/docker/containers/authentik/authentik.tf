locals {
  database = "authentik"
  db_user = "authentik"

  env = {
    mail = [
      # SMTP Host Emails are sent to
      "AUTHENTIK_EMAIL__HOST=${var.smtp_host}",
      "AUTHENTIK_EMAIL__PORT=${var.smtp_port}",

      # Use StartTLS
      "AUTHENTIK_EMAIL__USE_TLS=false",
      # Use SSL
      "AUTHENTIK_EMAIL__USE_SSL=false",
      "AUTHENTIK_EMAIL__TIMEOUT=10",
      # Email address authentik will send from, should have a correct @domain
      "AUTHENTIK_EMAIL__FROM=authentik@${var.fqdn}"
    ]
  }
}

resource "docker_network" "backend" {
  name = "backend"
}

module "database" {
  source = "../postgres"
  database = local.database
  name =  "authentik-db"
  network = docker_network.backend.name
  username = local.db_user
  password = var.db_password
}

module "redis" {
  source = "../redis"
  name = "authentik-redis"
  network = docker_network.backend.name
}

resource "docker_image" "server" {
  name = "ghcr.io/goauthentik/server:2022.9.0"
}


resource "docker_volume" "geoip" {

}

resource "docker_container" "authentik" {
  name  = "authentik-server"
  image = docker_image.server.image_id
  restart = "unless-stopped"

  command = ["server"]

  env = concat(local.env.mail, [
    # Postgres Configuration
    "AUTHENTIK_POSTGRESQL__NAME=${local.database}",
    "AUTHENTIK_POSTGRESQL__USER=${local.db_user}",
    "AUTHENTIK_POSTGRESQL__PASSWORD=${var.db_password}",
    "AUTHENTIK_POSTGRESQL__HOST=${module.database.container.name}",

    # Redis Configuration
    "AUTHENTIK_REDIS__HOST=${module.redis.container.name}",
    "AUTHENTIK_REDIS__PASSWORD=${module.redis.password}",

    "AUTHENTIK_SECRET_KEY=${var.secret}",
    "AUTHENTIK_AUTHENTIK__GEOIP=/geoip/GeoLite2-City.mmdb"
  ])

  volumes {
    container_path = "/geoip"
    volume_name = docker_volume.geoip.name
  }

  volumes {
    container_path = "/media"
    host_path = "${var.data_dir.path}/media"
  }

  volumes {
    container_path = "/templates"
    host_path = "${var.data_dir.path}/templates"
  }


  depends_on = [
    module.database.container,
    module.redis.container
  ]

  # Backend Network
  networks_advanced {
    name = docker_network.backend.name
  }

  # Traefik Network
  networks_advanced {
    name = var.traefik_network
  }
}


resource "docker_container" "authentik_worker" {
  name  = "authentik-worker"
  image = docker_image.server.image_id
  restart = "unless-stopped"

  command = ["worker"]

  env = concat(local.env.mail, [
    # Postgres Configuration
    "AUTHENTIK_POSTGRESQL__NAME=${local.database}",
    "AUTHENTIK_POSTGRESQL__USER=${local.db_user}",
    "AUTHENTIK_POSTGRESQL__PASSWORD=${var.db_password}",
    "AUTHENTIK_POSTGRESQL__HOST=${module.database.container.name}",

    # Redis Configuration
    "AUTHENTIK_REDIS__HOST=${module.redis.container.name}",
    "AUTHENTIK_REDIS__PASSWORD=${module.redis.password}",

    "AUTHENTIK_SECRET_KEY=${var.secret}",
    "AUTHENTIK_AUTHENTIK__GEOIP=/geoip/GeoLite2-City.mmdb"
  ])

  volumes {
    container_path = "/geoip"
    volume_name = docker_volume.geoip.name
  }

  volumes {
    container_path = "/media"
    host_path = "${var.data_dir.path}/media"
  }

  volumes {
    container_path = "/templates"
    host_path = "${var.data_dir.path}/templates"
  }


  depends_on = [
    module.database.container,
    module.redis.container
  ]

  # Backend Network
  networks_advanced {
    name = docker_network.backend.name
  }
}

resource "docker_image" "geoip" {
  name = "maxmindinc/geoipupdate:v4.9"
}

resource "docker_container" "geoip" {
  image = docker_image.geoip.image_id
  name  = "geoip"

  volumes {
    container_path = "/usr/share/GeoIP"
    volume_name = docker_volume.geoip.name
  }

  env = [
    "GEOIPUPDATE_EDITION_IDS=GeoLite2-City",
    "GEOIPUPDATE_FREQUENCY=8",
    "GEOIPUPDATE_ACCOUNT_ID=${var.geoip_account}",
    "GEOIPUPDATE_LICENSE_KEY=${var.geoip_license}"
  ]
}