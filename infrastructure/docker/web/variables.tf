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

variable "nextcloud_db_password" {
  type        = string
  sensitive   = true
}

variable "nextcloud_db_root_password" {
  type        = string
  sensitive   = true
}

variable "gitea_db_password" {
  type        = string
  sensitive   = true
}

variable "gitea_db_root_password" {
  type        = string
  sensitive   = true
}