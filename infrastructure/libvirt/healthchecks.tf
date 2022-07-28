variable "healthchecksio_api_key" {
  type = string
  sensitive = true
}

provider "healthchecksio" {
  api_key = var.healthchecksio_api_key
}

data "healthchecksio_channel" "email" {
  kind = "email"
}

resource "healthchecksio_check" "snapraid_media" {
  name = "SnapRAID Media"

  grace = 3600 # 1h in seconds
  schedule = "5 4 * * *"

  timezone  = "Europe/Berlin"

  channels = [
    data.healthchecksio_channel.email.id
  ]
}
