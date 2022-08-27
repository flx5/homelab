variable "internal_network_name" {
  type        = string
}

variable "wan_network_name" {
  type        = string
}

variable "homelab_ca" {
  type        = string
}

variable "homelab_ca_cert" {
  type        = string
}

variable "configurations" {
  type = map(string)
}

variable "additional_entrypoints" {
  type = map(number)
}

variable "hostname" {
  type = string
  default = "traefik"
}

variable "acme_email" {
  type = string
  default = ""
  sensitive = true
}

variable "cloudflare_email" {
  type = string
  default = ""
  sensitive = true
}

variable "cloudflare_api_key" {
  type = string
  default = ""
  sensitive = true
}