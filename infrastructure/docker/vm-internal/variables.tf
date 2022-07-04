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

variable "mail_mydomain" {
  type        = string
}

variable "mail_relayhost" {
  type        = string
}

variable "mail_relayport" {
  type        = string
}

variable "mail_relayuser" {
  type        = string
}

variable "mail_relaypassword" {
  type        = string
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