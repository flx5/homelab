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

variable "nextcloud_db_password" {
  type        = string
  sensitive   = true
}