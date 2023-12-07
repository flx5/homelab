locals {
  database = "nextcloud"
  db_user = "nextcloud"
}

resource "docker_image" "nextcloud" {
  name = "ghcr.io/flx5/nextcloud-full-image:v27.1.4"
}

resource "docker_network" "nextcloud_backend" {
  name = "nextcloud_backend"
}

module "database" {
  source = "../mariadb"
  database = local.database
  name =  "nextcloud-db"
  network = docker_network.nextcloud_backend.name
  username = local.db_user
  password = var.db_password
  root_password = var.db_root_password
  command = ["--transaction-isolation=READ-COMMITTED", "--log-bin=ROW", "--innodb_read_only_compressed=OFF"]
}

module "redis" {
  source = "../redis"
  name = "nextcloud-redis"
  network = docker_network.nextcloud_backend.name
}

resource "docker_container" "nextcloud" {
  for_each = {
    app = {
      entrypoint = [ "/entrypoint.sh" ]
      command = [ "apache2-foreground" ]
    }
    cron = {
      entrypoint = [ "/cron.sh" ]
      command = []
    }
  }

  name  = "nextcloud-${each.key}"
  image = docker_image.nextcloud.image_id
  restart = "unless-stopped"
  entrypoint = each.value.entrypoint
  command = each.value.command

  env = [
    # MySQL Configuration
    "MYSQL_DATABASE=${local.database}",
    "MYSQL_USER=${local.db_user}",
    "MYSQL_PASSWORD=${var.db_password}",
    "MYSQL_HOST=${module.database.container.name}",

    # Redis Configuration
    "REDIS_HOST=${module.redis.container.name}",
    "REDIS_HOST_PASSWORD=${module.redis.password}",

    # Domain configuration
    "OVERWRITEPROTOCOL=https",
    "OVERWRITEHOST=${var.fqdn}",
    "OVERWRITECLIURL=https://${var.fqdn}",

    # Mail Configuration
    "SMTP_HOST=${var.smtp_host}",
    "SMTP_PORT=${var.smtp_port}",
    "SMTP_AUTHTYPE=PLAIN",
    "MAIL_FROM_ADDRESS=nextcloud",
    "MAIL_DOMAIN=nextcloud.local",
    # TODO Configure SMTP (From) correctly

    # Proxy Configuration
    "TRUSTED_PROXIES=${var.traefik_host}",

    # Place data somewhere different because this container very happily will
    # overwrite everything in /var/www/html when updating the nextcloud version.
    # This prevents accidentially configuring the data volume as the /var/www/html volume
    "NEXTCLOUD_DATA_DIR=/mnt/data"
  ]

  volumes {
    container_path = "/var/www/html"
    host_path = var.app_folder.path
  }

  volumes {
    container_path = "/mnt/data"
    host_path = var.data_dir.path
  }

  dynamic "volumes" {
    for_each = var.additional_volumes
    content {
      container_path = "/mnt/volumes/${volumes.value.name}"
      host_path = volumes.value.path
    }
  }

  depends_on = [
    module.database.container,
    module.redis.container
  ]

  # Backend Network
  networks_advanced {
    name = docker_network.nextcloud_backend.name
  }

  # Traefik Network
  networks_advanced {
    name = var.traefik_network
  }
}
