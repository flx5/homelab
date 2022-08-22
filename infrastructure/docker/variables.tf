variable "hypervisor_host" {
  type        = string
}

variable "hypervisor_user" {
  type        = string
}

variable "docker_web_host" {
  type        = string
}

variable "docker_web_user" {
  type        = string
}

variable "docker_media_host" {
  type        = string
}

variable "docker_media_user" {
  type        = string
}

variable "docker_internal_host" {
  type        = string
}

variable "docker_internal_user" {
  type        = string
}

variable "web_gitea_db_password" {
  type        = string
  sensitive   = true
}

variable "web_gitea_db_root_password" {
  type        = string
  sensitive   = true
}

variable "web_nextcloud_db_password" {
  type        = string
  sensitive   = true
}

variable "web_nextcloud_db_root_password" {
  type        = string
  sensitive   = true
}

variable "internal_nextcloud_db_password" {
  type        = string
  sensitive   = true
}

variable "internal_nextcloud_db_root_password" {
  type        = string
  sensitive   = true
}

variable "internal_auth_username" {
  type        = string
  sensitive   = true
}

variable "internal_auth_password" {
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

variable "sftp_user" {
  type        = string
  sensitive = true
}

variable "sftp_password" {
  type        = string
  sensitive = true
}

variable "sftp_host" {
  type        = string
  sensitive = true
}
