variable "traefik_network" {
  type        = string
}

variable "smtp_host" {
  type        = string
}

variable "smtp_port" {
  type        = number
}

variable "traefik_host" {
  type = string
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

variable "data_dir" {
  type = string
}
