variable "base_domain" {
  type = string
}

variable "acme_email" {
  type = string
}

variable "cloudflare_email" {
  type        = string
  sensitive   = true
}

variable "cloudflare_api_key" {
  type        = string
  sensitive   = true
}

variable "homelab_ca" {
  type        = string
}

variable "homelab_ca_cert" {
  type        = string
}