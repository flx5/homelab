variable "cloudflare_email" {
  type        = string
  sensitive   = true
}

variable "cloudflare_api_key" {
  type        = string
  sensitive   = true
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}


variable "zone_id" {
  type = string
}

resource "cloudflare_record" "dns_web" {
  for_each = module.web.hostnames

  zone_id = var.zone_id
  name    = each.value.url
  value   = each.value.public ? var.public_ip : var.docker_web_host
  type    = each.value.public ? var.record_type : "A"
  ttl     = 3600
}

# TODO Remove once not used by services anymore...
resource "cloudflare_record" "dns_media" {
  for_each = module.media.hostnames

  zone_id = var.zone_id
  name    = each.value
  value   = var.docker_media_host
  type    = "A"
  ttl     = 3600
}