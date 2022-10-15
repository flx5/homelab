variable "ssh_id" {
  type = string
}

variable "host" {
  type = string
}

variable "admin_mail" {
  type = string
}

variable "media_mail" {
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