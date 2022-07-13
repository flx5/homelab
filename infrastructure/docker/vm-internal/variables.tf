variable "docker_host" {
  type        = string
}

variable "docker_user" {
  type        = string
}

variable "nextcloud_db_password" {
  type        = string
  sensitive   = true
}

variable "nextcloud_db_root_password" {
  type        = string
  sensitive   = true
}

variable "acme_email" {
  type = string
  sensitive   = true
}

variable "auth_username" {
  type = string
  sensitive   = true
}

variable "auth_password" {
  type = string
  sensitive   = true
}
