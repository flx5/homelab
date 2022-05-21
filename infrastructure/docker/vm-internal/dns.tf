variable "cloudflare_email" {
  type        = string
  sensitive   = true
}

variable "cloudflare_api_key" {
  type        = string
  sensitive   = true
}

variable "base_domain" {
  type = string
}

variable "public_ip" {
  type = string
}

variable "record_type" {
  type = string
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}


variable "zone_id" {
  type = string
}

resource "cloudflare_record" "dns" {
  for_each = merge(local.hostnames, module.addons.hostnames)

  zone_id = var.zone_id
  name    = each.value
  value   = var.public_ip
  type    = var.record_type
  ttl     = 3600
}