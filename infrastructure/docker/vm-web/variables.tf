variable "docker_host" {
  type        = string
}

variable "docker_user" {
  type        = string
}

variable "gitea_db_password" {
  type        = string
  sensitive   = true
}

variable "gitea_db_root_password" {
  type        = string
  sensitive   = true
}

variable "nextcloud_db_password" {
  type        = string
  sensitive   = true
}

variable "nextcloud_db_root_password" {
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

variable "acme_email" {
  type = string
}
