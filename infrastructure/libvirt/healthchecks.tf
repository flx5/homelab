variable "healthchecksio_api_key" {
  type = string
  sensitive = true
}

provider "healthchecksio" {
  api_key = var.healthchecksio_api_key
}

resource "healthchecksio_check" "snapraid_media" {
  name = "SnapRAID Media"

  grace = 120 # in seconds
  schedule = "5 4 * * *"
}