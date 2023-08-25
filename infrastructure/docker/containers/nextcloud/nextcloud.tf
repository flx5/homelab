locals {
  database = "nextcloud"
  db_user = "nextcloud"
}

resource "docker_image" "nextcloud" {
  name = "localhost/nextcloud-full"
  # Build on remote takes very long. Disks seem to be too slow?!
  # Thus build locally and transfer via docker save + docker load
  # docker build . -t localhost/nextcloud-full
  # docker save localhost/nextcloud-full -o nextcloud-full.tar
  # Copy with scp
  # sudo docker load < nextcloud-full.tar
  #
  # TODO Need to analyze disk performance, the local build works within a minute!
  /*build {
    context = path.module
    tag  = ["nextcloud-full"]
    # Build the image on the server by copying the Dockerfile and running screen -L sudo docker build --progress=plain . -t nextcloud-cache
    # This is just a temporary workaround until the image is built via a seperate pipeline!
    cache_from = [
      "nextcloud-cache:latest"
    ]
    label = {
      trigger_dockerfile_hash = filemd5("${path.module}/Dockerfile")
      trigger_files_hash = join(", ", [ for file in fileset("${path.module}/files", "*") :  "${file}:${md5(file)}" ])
    }
  }*/
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
  name  = "nextcloud-app"
  image = docker_image.nextcloud.image_id
  restart = "unless-stopped"

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
