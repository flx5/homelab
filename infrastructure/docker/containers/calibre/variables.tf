variable "traefik_network" {
  type        = string
}

variable "fqdn" {
  type = string
}

variable "books_path" {
  type = object({
    path: string
    backup: bool
  })
}

variable "config_path" {
  type = object({
    path: string
    backup: bool
  })
}