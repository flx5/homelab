variable "smtp_host" {
  type        = string
}

variable "smtp_port" {
  type        = number
}

variable "traefik_network" {
  type = string
}

variable "geoip_account" {
  type        = string
  sensitive   = true
}

variable "geoip_license" {
  type        = string
  sensitive   = true
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "secret" {
  type        = string
  sensitive   = true
}

variable "fqdn" {
  type = string
}

variable "dump_folder" {
  type = string
}

variable "data_dir" {
  type = object({
    path: string
    backup: bool
  })
}

variable "cert_resolver" {
  type = string
  default = "letsencrypt"
}