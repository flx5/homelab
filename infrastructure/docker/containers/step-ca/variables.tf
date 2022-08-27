variable "traefik_network" {
  type        = string
}

variable "config_dir" {
  type = object({
    path: string
    backup: bool
  })
}

variable "fqdn" {
  type = string
}

variable "ip_address" {
  type = string
}