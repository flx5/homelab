variable "traefik_network" {
  type        = string
}

variable "smtp_host" {
  type        = string
}

variable "smtp_port" {
  type        = number
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "db_root_password" {
  type        = string
  sensitive   = true
}

variable "fqdn" {
  type = string
}
