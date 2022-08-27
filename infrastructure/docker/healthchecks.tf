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

resource "healthchecksio_check" "backup" {
  name = "Backup"

  grace = 86400 # 1 day in seconds, because this job can run very long...
  schedule = "5 2 * * *"

  timezone  = "Europe/Berlin"

  channels = [
    data.healthchecksio_channel.email.id
  ]
}
