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

variable "dump_folder" {
  type = string
}

variable "data_dir" {
  type = object({
    path: string
    backup: bool
  })
}

variable "app_folder" {
  type = object({
    path: string
    backup: bool
  })
}

variable "cert_resolver" {
  type = string
  default = "letsencrypt"
}