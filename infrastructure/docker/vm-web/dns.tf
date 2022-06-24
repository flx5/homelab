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

resource "cloudflare_record" "dns" {
  for_each = local.hostnames

  zone_id = var.zone_id
  name    = each.value
  value   = var.public_ip
  type    = var.record_type
  ttl     = 3600
}

resource "cloudflare_record" "mailer" {
  zone_id = var.zone_id
  name    = "internal-mailer"
  value   = var.docker_host
  type    = "A"
  ttl     = 3600
}