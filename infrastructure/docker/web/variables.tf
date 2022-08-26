variable "smtp_host" {
  type        = string
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

variable "base_domain" {
  type = string
}

variable "dump_folder" {
  type = string
}