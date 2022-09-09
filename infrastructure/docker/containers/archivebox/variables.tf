variable "data_path" {
  type = object({
    path: string
    backup: bool
  })
}

variable "cert_resolver" {
  type = string
  default = "letsencrypt"
}

variable "traefik_network" {
  type        = string
}

variable "fqdn" {
  type = string
}