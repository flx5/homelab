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

variable "smtp_host" {
  type        = string
}

variable "auth_username" {
  type = string
  sensitive   = true
}

variable "auth_password" {
  type = string
  sensitive   = true
}

variable "dump_folder" {
  type = string
}