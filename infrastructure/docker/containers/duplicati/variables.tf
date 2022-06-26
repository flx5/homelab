variable "traefik_network" {
  type        = string
}

variable "mail_network" {
  type        = string
}

variable "fqdn" {
  type = string
}

variable "volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = bool
  }))

  default = []
}

variable "networks" {
  type = list(string)
  default = []
}

variable "scripts" {
  type = map(string)
  default = {}
}