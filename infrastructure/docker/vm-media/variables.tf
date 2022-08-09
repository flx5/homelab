variable "docker_host" {
  type        = string
}

variable "docker_user" {
  type        = string
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

variable "acme_email" {
  type = string
}

