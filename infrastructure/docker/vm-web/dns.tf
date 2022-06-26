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
  name    = each.value.url
  value   = each.value.public ? var.public_ip : var.docker_host
  type    = each.value.public ? var.record_type : "A"
  ttl     = 3600
}