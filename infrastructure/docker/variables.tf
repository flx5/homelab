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
