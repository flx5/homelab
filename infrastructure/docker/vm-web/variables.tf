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

variable "base_domain" {
  type = string
}

variable "public_ip" {
  type = string
}

variable "record_type" {
  type = string
}